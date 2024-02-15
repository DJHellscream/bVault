// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {ERC20Votes} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {Nonces} from "@openzeppelin/contracts/utils/Nonces.sol";

/// @dev ERC-4626 vault with entry/exit fees expressed in https://en.wikipedia.org/wiki/Basis_point[basis point (bp)].
/// @notice modifications from the wiki source made by @therealbifkn
/// @custom:security-contact @therealbifkn
abstract contract ERC4626Fees is ERC4626, ERC20Permit, ERC20Votes {
    using Math for uint256;

    uint256 private constant _BASIS_POINT_SCALE = 1e4;
    address internal constant BURN_ADDRESS =
        0x000000000000000000000000000000000000dEaD;
    uint256 private constant BURN_FEE = 25;
    /// @notice addresses exempt from transfer fees
    mapping(address => bool) isTransferFeeExempt;

    // === Overrides ===

    /// @dev required by solidity
    function decimals()
        public
        view
        virtual
        override(ERC4626, ERC20)
        returns (uint8)
    {
        return super.decimals();
    }

    /// @dev takes into account any vault tokens that were sent to the dead address
    function totalSupply()
        public
        view
        virtual
        override(ERC20, IERC20)
        returns (uint256)
    {
        return super.totalSupply() - balanceOf(BURN_ADDRESS);
    }

    /**
     * @dev Returns the underlying asset balance of `account` which can be used by Governor
     */
    function _getVotingUnits(
        address account
    ) internal view virtual override returns (uint256) {
        return convertToAssets(balanceOf(account));
    }

    /// @dev required by solidity
    /// @param from from address
    /// @param to to address
    /// @param value value to update to
    function _update(
        address from,
        address to,
        uint256 value
    ) internal virtual override(ERC20, ERC20Votes) {
        super._update(from, to, value);
    }

    /// @dev required by solidity
    /// @param owner owner of the tokens
    function nonces(
        address owner
    ) public view override(ERC20Permit, Nonces) returns (uint256) {
        return super.nonces(owner);
    }

    /// @dev Preview taking an entry fee on deposit. See {IERC4626-previewDeposit}.
    function previewDeposit(
        uint256 assets
    ) public view virtual override returns (uint256) {
        uint256 fee = _feeOnTotal(assets, _entryFeeBasisPoints());
        return super.previewDeposit(assets - fee);
    }

    /// @dev Preview adding an entry fee on mint. See {IERC4626-previewMint}.
    function previewMint(
        uint256 shares
    ) public view virtual override returns (uint256) {
        uint256 assets = super.previewMint(shares);
        return assets + _feeOnRaw(assets, _entryFeeBasisPoints());
    }

    /// @dev Preview adding an exit fee on withdraw. See {IERC4626-previewWithdraw}.
    function previewWithdraw(
        uint256 assets
    ) public view virtual override returns (uint256) {
        uint256 fee = _feeOnRaw(assets, _exitFeeBasisPoints());
        return super.previewWithdraw(assets + fee);
    }

    /// @dev Preview taking an exit fee on redeem. See {IERC4626-previewRedeem}.
    function previewRedeem(
        uint256 shares
    ) public view virtual override returns (uint256) {
        uint256 assets = super.previewRedeem(shares);
        return assets - _feeOnTotal(assets, _exitFeeBasisPoints());
    }

    /// @dev overridden to collect fees on transfer
    /// @param to to address
    /// @param value value to transfer
    function transfer(
        address to,
        uint256 value
    ) public virtual override(ERC20, IERC20) returns (bool) {
        uint256 fee = _feeOnTotal(value, _transferFeeBasisPoints());
        uint256 burnFee = _feeOnTotal(value, BURN_FEE);
        address recipient = _transferFeeRecipient();
        uint256 amount = value;
        bool exempt = isTransferFeeExempt[_msgSender()] ||
            isTransferFeeExempt[to];

        if (!exempt) {
            // Burn .25% of all transfers
            super._burn(_msgSender(), burnFee);
            amount -= burnFee;

            if (fee > 0 && recipient != address(this)) {
                super.transfer(recipient, fee);

                amount -= fee;
            }
        }

        return super.transfer(to, amount);
    }

    /// @dev overridden to collect fees on transfer
    /// @param from from address
    /// @param to to address
    /// @param value value to transfer
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public virtual override(ERC20, IERC20) returns (bool) {
        uint256 fee = _feeOnTotal(value, _transferFeeBasisPoints());
        uint256 burnFee = _feeOnTotal(value, BURN_FEE);
        address recipient = _transferFeeRecipient();
        uint256 amount = value;
        bool exempt = isTransferFeeExempt[from] || isTransferFeeExempt[to];

        if (!exempt) {
            // Burn .25% of all transfers
            _burn(from, burnFee);
            amount -= burnFee;

            if (fee > 0 && recipient != address(this)) {
                super.transferFrom(from, recipient, fee);

                amount -= fee;
            }
        }

        return super.transferFrom(from, to, amount);
    }

    /// @dev Send entry fee to {_entryFeeRecipient}. See {IERC4626-_deposit}.
    function _deposit(
        address caller,
        address receiver,
        uint256 assets,
        uint256 shares
    ) internal virtual override {
        uint256 fee = _feeOnTotal(assets, _entryFeeBasisPoints());
        address recipient = _entryFeeRecipient();

        super._deposit(caller, receiver, assets, shares);

        if (fee > 0 && recipient != address(this)) {
            SafeERC20.safeTransfer(IERC20(asset()), recipient, fee);
        }
    }

    /// @dev Send exit fee to {_exitFeeRecipient}. See {IERC4626-_deposit}.
    function _withdraw(
        address caller,
        address receiver,
        address owner,
        uint256 assets,
        uint256 shares
    ) internal virtual override {
        uint256 fee = _feeOnRaw(assets, _exitFeeBasisPoints());
        address recipient = _exitFeeRecipient();

        super._withdraw(caller, receiver, owner, assets, shares);

        if (fee > 0 && recipient != address(this)) {
            SafeERC20.safeTransfer(IERC20(asset()), recipient, fee);
        }

        // If there are no more vault tokens then remove any dust from contract
        // otherwise it's possible no more vault tokens could be issued.
        if (totalSupply() < 1) {
            SafeERC20.safeTransfer(IERC20(asset()), recipient, totalAssets());
        }
    }

    // === Fee configuration ===

    function _entryFeeBasisPoints() internal view virtual returns (uint256) {
        //return 0; // replace with e.g. 100 for 1%
    }

    function _exitFeeBasisPoints() internal view virtual returns (uint256) {
        //return 0; // replace with e.g. 100 for 1%
    }

    function _transferFeeBasisPoints() internal view virtual returns (uint256) {
        //return 0; // replace with e.g. 100 for 1%
    }

    function _entryFeeRecipient() internal view virtual returns (address) {
        //return address(0); // replace with e.g. a treasury address
    }

    function _transferFeeRecipient() internal view virtual returns (address) {
        //return address(0);
    }

    function _exitFeeRecipient() internal view virtual returns (address) {
        //return address(0);
    }

    // === Fee operations ===

    /// @dev Calculates the fees that should be added to an amount `assets` that does not already include fees.
    /// Used in {IERC4626-mint} and {IERC4626-withdraw} operations.
    function _feeOnRaw(
        uint256 assets,
        uint256 feeBasisPoints
    ) private pure returns (uint256) {
        return
            assets.mulDiv(
                feeBasisPoints,
                _BASIS_POINT_SCALE,
                Math.Rounding.Ceil
            );
    }

    /// @dev Calculates the fee part of an amount `assets` that already includes fees.
    /// Used in {IERC4626-deposit} and {IERC4626-redeem} operations.
    function _feeOnTotal(
        uint256 assets,
        uint256 feeBasisPoints
    ) private pure returns (uint256) {
        return
            assets.mulDiv(
                feeBasisPoints,
                feeBasisPoints + _BASIS_POINT_SCALE,
                Math.Rounding.Ceil
            );
    }
}
