// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

/// @title Kimbo School Vault
/// @author @therealbifkn

// ▄    ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄       ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄
//▐░▌  ▐░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌     ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌
//▐░▌ ▐░▌  ▀▀▀▀█░█▀▀▀▀ ▐░▌░▌   ▐░▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌     ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌
//▐░▌▐░▌       ▐░▌     ▐░▌▐░▌ ▐░▌▐░▌▐░▌       ▐░▌▐░▌       ▐░▌     ▐░▌          ▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌
//▐░▌░▌        ▐░▌     ▐░▌ ▐░▐░▌ ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌          ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌
//▐░░▌         ▐░▌     ▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░▌ ▐░▌       ▐░▌     ▐░░░░░░░░░░░▌▐░▌          ▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌
//▐░▌░▌        ▐░▌     ▐░▌   ▀   ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌      ▀▀▀▀▀▀▀▀▀█░▌▐░▌          ▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌
//▐░▌▐░▌       ▐░▌     ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌               ▐░▌▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌▐░▌
//▐░▌ ▐░▌  ▄▄▄▄█░█▄▄▄▄ ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌      ▄▄▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄
//▐░▌  ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌     ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
// ▀    ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀       ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀

import "hardhat/console.sol";
import "./ERC4626Fees.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract KimboSchool is ERC4626Fees, Ownable(msg.sender) {
    address payable public entryFeeTreasury;
    address payable public exitFeeTreasury;
    address payable public transferFeeTreasury;
    uint256 public entryFeeBasisPoints = 500;
    uint256 public exitFeeBasisPoints = 100;
    uint256 public transferFeeBasisPoints = 100;

    error FeeOutOfBounds();

    constructor(
        IERC20 _asset,
        address treasuryAddress
    )
        ERC4626(_asset)
        ERC20("Kimbo School", "xKimbo")
        ERC20Permit("Kimbo School")
    {
        entryFeeTreasury = payable(treasuryAddress);
        exitFeeTreasury = payable(treasuryAddress);
        transferFeeTreasury = payable(treasuryAddress);
    }

    /** @dev See {IERC4626-deposit}. */
    function deposit(
        uint256 assets,
        address receiver
    ) public virtual override returns (uint256) {
        require(
            assets <= maxDeposit(receiver),
            "ERC4626: deposit more than max"
        );

        uint256 shares = previewDeposit(assets);
        _deposit(_msgSender(), receiver, assets, shares);
        afterDeposit(assets, shares);

        return shares;
    }

    /** @dev See {IERC4626-mint}.
     *
     * As opposed to {deposit}, minting is allowed even if the vault is in a state where the price of a share is zero.
     * In this case, the shares will be minted without requiring any assets to be deposited.
     */
    function mint(
        uint256 shares,
        address receiver
    ) public virtual override returns (uint256) {
        require(shares <= maxMint(receiver), "ERC4626: mint more than max");

        uint256 assets = previewMint(shares);
        _deposit(_msgSender(), receiver, assets, shares);
        afterDeposit(assets, shares);

        return assets;
    }

    /** @dev See {IERC4626-redeem}. */
    function redeem(
        uint256 shares,
        address receiver,
        address owner
    ) public virtual override returns (uint256) {
        require(shares <= maxRedeem(owner), "ERC4626: redeem more than max");

        uint256 assets = previewRedeem(shares);
        beforeWithdraw(assets, shares);
        _withdraw(_msgSender(), receiver, owner, assets, shares);

        return assets;
    }

    /** @dev See {IERC4626-withdraw}. */
    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) public virtual override returns (uint256) {
        require(
            assets <= maxWithdraw(owner),
            "ERC4626: withdraw more than max"
        );

        uint256 shares = previewWithdraw(assets);
        beforeWithdraw(assets, shares);
        _withdraw(_msgSender(), receiver, owner, assets, shares);

        return shares;
    }

    function _entryFeeBasisPoints() internal view override returns (uint256) {
        return entryFeeBasisPoints;
    }

    function _exitFeeBasisPoints() internal view override returns (uint256) {
        return exitFeeBasisPoints;
    }

    function _transferFeeBasisPoints()
        internal
        view
        override
        returns (uint256)
    {
        return transferFeeBasisPoints;
    }

    function _entryFeeRecipient() internal view override returns (address) {
        return entryFeeTreasury;
    }

    function _exitFeeRecipient() internal view override returns (address) {
        return exitFeeTreasury;
    }

    function _transferFeeRecipient() internal view override returns (address) {
        return transferFeeTreasury;
    }

    function setEntryFeeBasisPoints(
        uint256 _newEntryFeeBasisPoints
    ) external onlyOwner {
        // require(
        //     _newEntryFeeBasisPoints >= 0 && _newEntryFeeBasisPoints <= 500,
        //     "Invalid fee"
        // );
        if (_newEntryFeeBasisPoints < 0) revert FeeOutOfBounds();
        if (_newEntryFeeBasisPoints > 500) revert FeeOutOfBounds();

        entryFeeBasisPoints = _newEntryFeeBasisPoints;
    }

    function setExitFeeBasisPoints(
        uint256 _newExitFeeBasisPoints
    ) external onlyOwner {
        require(
            _newExitFeeBasisPoints >= 0 && _newExitFeeBasisPoints <= 500,
            "Invalid fee"
        );
        exitFeeBasisPoints = _newExitFeeBasisPoints;
    }

    function setTransferFeeBasisPoints(
        uint256 _newTransferFeeBasisPoints
    ) external onlyOwner {
        require(
            _newTransferFeeBasisPoints >= 0 &&
                _newTransferFeeBasisPoints <= 500,
            "Invalid fee"
        );
        transferFeeBasisPoints = _newTransferFeeBasisPoints;
    }

    function setEntryFeeRecipient(
        address entryFeeRecipient
    ) external onlyOwner {
        entryFeeTreasury = payable(entryFeeRecipient);
    }

    function setExitFeeRecipient(address exitFeeRecipient) external onlyOwner {
        exitFeeTreasury = payable(exitFeeRecipient);
    }

    function setTransferFeeRecipient(
        address transferFeeRecipient
    ) external onlyOwner {
        transferFeeTreasury = payable(transferFeeRecipient);
    }

    /*//////////////////////////////////////////////////////////////
                          INTERNAL HOOKS LOGIC
    //////////////////////////////////////////////////////////////*/

    function afterDeposit(uint256 assets, uint256 shares) internal virtual {}

    function beforeWithdraw(uint256 assets, uint256 shares) internal virtual {}
}
