// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

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

import {ERC4626Fees, IERC20, ERC4626, ERC20, ERC20Permit, SafeERC20} from "./ERC4626Fees.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title Kimbo School Vault
/// @author @therealbifkn
/// @custom:security-contact @therealbifkn
contract KimboSchool is ERC4626Fees, Ownable(msg.sender) {
    /// @notice address for fees
    address payable public feeTreasury;
    /// @notice address for transfer fees
    address payable public transferFeeTreasury;
    /// @notice fee for deposit/mint in basis points
    uint256 public entryFee = 300;
    /// @notice fee for withdraw/redeem in basis points
    uint256 public exitFee = 100;
    /// @notice fee on transfer in basis points
    uint256 public transferFee = 25;

    /// @dev fee is out of bounds - should be >= 0 and <= 500 (75 for transfer)
    error FeeOutOfRange();
    /// @dev fee recipient can not be the address of this contract
    error InvalidFeeRecipient();
    /// @dev can not resuce the underlying token
    error RescueUnderlying();
    /// @dev can't acccept native transfer
    error NativeNotAllowed();
    /// @dev burn address can't be exempt
    error InvalidExemptAddress();

    /// Event for when fees are updated - all in basis points
    /// @param caller caller (should be owner)
    /// @param newEntryFee new fee value
    /// @param newExitFee new fee value
    /// @param newTransferFee new fee value
    event FeeUpdated(
        address indexed caller,
        uint256 newEntryFee,
        uint256 newExitFee,
        uint256 newTransferFee
    );

    /// Event for when of the fee recipient addresses is updated
    /// @param caller caller (should be owner)
    /// @param newFeeRecipient new entry fee recipient address
    event TreasuryUpdated(address indexed caller, address newFeeRecipient);

    /// Constructor
    /// @param _asset Underlying ERC20 asset
    /// @param treasuryAddress initial address for fee recipient
    constructor(
        IERC20 _asset,
        address treasuryAddress,
        address transferFeeAddress
    )
        ERC4626(_asset)
        ERC20("Kimbo School", "gKimbo")
        ERC20Permit("Kimbo School")
    {
        feeTreasury = payable(treasuryAddress);
        transferFeeTreasury = payable(transferFeeAddress);

        /// Exempt treasury for initial distribution to TraderJoe LP
        isTransferFeeExempt[treasuryAddress] = true;

        emit TreasuryUpdated(msg.sender, treasuryAddress);
    }

    function _entryFeeBasisPoints() internal view override returns (uint256) {
        return entryFee;
    }

    function _exitFeeBasisPoints() internal view override returns (uint256) {
        return exitFee;
    }

    function _transferFeeBasisPoints()
        internal
        view
        override
        returns (uint256)
    {
        return transferFee;
    }

    function _feeRecipient() internal view override returns (address) {
        return feeTreasury;
    }

    function _transferFeeRecipient() internal view override returns (address) {
        return transferFeeTreasury;
    }

    function setTransferFeeExempt(
        address _address,
        bool isExempt
    ) external onlyOwner {
        if (_address == address(0) || _address == BURN_ADDRESS)
            revert InvalidExemptAddress();

        isTransferFeeExempt[_address] = isExempt;
    }

    /// @dev Set fees for entry, exit, and transfer. These all need to be in basis points. e.g. 100 = 1%
    /// @param _entryFee new fee for deposit/mint
    /// @param _exitFee new fee for redeem/withdraw
    /// @param _transferFee new fee for transfers
    function setFees(
        uint256 _entryFee,
        uint256 _exitFee,
        uint256 _transferFee
    ) external onlyOwner {
        if (_entryFee < 0 || _entryFee > 500) revert FeeOutOfRange();
        if (_exitFee < 0 || _exitFee > 500) revert FeeOutOfRange();
        if (_transferFee < 0 || _transferFee > 75) revert FeeOutOfRange();

        entryFee = _entryFee;
        exitFee = _exitFee;
        transferFee = _transferFee;

        emit FeeUpdated(_msgSender(), _entryFee, _exitFee, _transferFee);
    }

    /// @dev Set new recipient for fees on entry, exit, and transfer. Can not be this contract
    /// @param _newFeeRecipient New fee recipient
    function setFeeRecipient(address _newFeeRecipient) external onlyOwner {
        if (_newFeeRecipient == address(this)) revert InvalidFeeRecipient();

        feeTreasury = payable(_newFeeRecipient);

        emit TreasuryUpdated(_msgSender(), _newFeeRecipient);
    }

    function setTransferFeeRecipient(
        address _newTransferFeeRecipient
    ) external onlyOwner {
        if (_newTransferFeeRecipient == address(this))
            revert InvalidFeeRecipient();

        transferFeeTreasury = payable(_newTransferFeeRecipient);

        emit TreasuryUpdated(_msgSender(), _newTransferFeeRecipient);
    }

    /// @dev This is to get incorrectly sent tokens out of the contract
    /// @param _token token contract of the tokens to be withdrawn
    /// @param _recipient address to transfer to
    /// @param _amount amount to withdraw
    function rescueToken(
        address _token,
        address _recipient,
        uint256 _amount
    ) external onlyOwner {
        if (_token == asset()) revert RescueUnderlying();

        SafeERC20.safeTransfer(IERC20(_token), _recipient, _amount);
    }

    /// @dev Fallback function to reject Native currency.
    receive() external payable {
        revert NativeNotAllowed();
    }

    /// @dev Fallback function to reject Native currency.
    fallback() external payable {
        revert NativeNotAllowed();
    }
}
