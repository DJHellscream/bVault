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

import {ERC4626Fees, IERC20, ERC4626, ERC20, ERC20Permit} from "./ERC4626Fees.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title Kimbo School Vault
/// @author @therealbifkn
/// @custom:security-contact @therealbifkn
contract KimboSchool is ERC4626Fees, Ownable(msg.sender) {
    /// @notice address for entry fees
    address payable public entryFeeTreasury;
    /// @notice address for exit fees
    address payable public exitFeeTreasury;
    /// @notice address for transfer fees
    address payable public transferFeeTreasury;
    /// @notice fee for deposit/mint in basis points
    uint256 public entryFee = 500;
    /// @notice fee for withdraw/redeem in basis points
    uint256 public exitFee = 100;
    /// @notice fee on transfer in basis points
    uint256 public transferFee = 50;

    /// @dev fee is out of bounds - should be > 0 and less than 500
    error FeeOutOfBounds();
    /// @dev fee recipient can not be the address of this contract
    error InvalidFeeRecipient();
    /// @dev can not resuce the underlying token
    error RescueUnderlying();

    /// Event for when fees are updated
    /// @param caller caller (should be owner)
    /// @param newFee new fee value
    event FeeUpdated(address indexed caller, uint256 newFee);
    /// Event for when of the fee recipient addresses is updated
    /// @param caller calelr (should be owner)
    /// @param newAddress new fee recipient address
    event TreasuryUpdated(address indexed caller, address newAddress);

    /// Constructor
    /// @param _asset Underlying ERC20 asset
    /// @param treasuryAddress initial address for fee recipient
    constructor(
        IERC20 _asset,
        address treasuryAddress
    )
        ERC4626(_asset)
        ERC20("Kimbo School", "tKimbo")
        ERC20Permit("Kimbo School")
    {
        entryFeeTreasury = payable(treasuryAddress);
        exitFeeTreasury = payable(treasuryAddress);
        transferFeeTreasury = payable(treasuryAddress);

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

    function _entryFeeRecipient() internal view override returns (address) {
        return entryFeeTreasury;
    }

    function _exitFeeRecipient() internal view override returns (address) {
        return exitFeeTreasury;
    }

    function _transferFeeRecipient() internal view override returns (address) {
        return transferFeeTreasury;
    }

    /// set new entry fee
    /// @param _newFeeBasisPoints set Entry Fee to new Basis Point
    function setEntryFee(uint256 _newFeeBasisPoints) external onlyOwner {
        if (_newFeeBasisPoints < 0 || _newFeeBasisPoints > 500)
            revert FeeOutOfBounds();

        entryFee = _newFeeBasisPoints;

        emit FeeUpdated(_msgSender(), _newFeeBasisPoints);
    }

    /// Set new exit fee
    /// @param _newFeeBasisPoints set Exit Fee to new Basis Point
    function setExitFee(uint256 _newFeeBasisPoints) external onlyOwner {
        if (_newFeeBasisPoints < 0 || _newFeeBasisPoints > 500)
            revert FeeOutOfBounds();

        exitFee = _newFeeBasisPoints;

        emit FeeUpdated(_msgSender(), _newFeeBasisPoints);
    }

    /// set new transfer fee
    /// @param _newFeeBasisPoints set Transfer Fee to new Basis Point
    function setTransferFee(uint256 _newFeeBasisPoints) external onlyOwner {
        if (_newFeeBasisPoints < 0 || _newFeeBasisPoints > 500)
            revert FeeOutOfBounds();

        transferFee = _newFeeBasisPoints;

        emit FeeUpdated(_msgSender(), _newFeeBasisPoints);
    }

    /// set new entry fee recipient
    /// @param feeRecipient set Entry Fee Recipient
    function setEntryFeeRecipient(address feeRecipient) external onlyOwner {
        if (feeRecipient == address(this)) revert InvalidFeeRecipient();

        entryFeeTreasury = payable(feeRecipient);

        emit TreasuryUpdated(_msgSender(), feeRecipient);
    }

    /// set new exit fee recipient
    /// @param feeRecipient set Exit Fee Recipient
    function setExitFeeRecipient(address feeRecipient) external onlyOwner {
        if (feeRecipient == address(this)) revert InvalidFeeRecipient();
        exitFeeTreasury = payable(feeRecipient);

        emit TreasuryUpdated(_msgSender(), feeRecipient);
    }

    /// set new transfer fee recipient
    /// @param feeRecipient set Transfer Fee Recipient
    function setTransferFeeRecipient(address feeRecipient) external onlyOwner {
        if (feeRecipient == address(this)) revert InvalidFeeRecipient();
        transferFeeTreasury = payable(feeRecipient);

        emit TreasuryUpdated(_msgSender(), feeRecipient);
    }

    /// This is to get incorrectly sent tokens out of the contract
    /// @param _token token contract of the tokens to be withdrawn
    /// @param _recipient address to transfer to
    /// @param _amount amount to withdraw
    function rescueToken(
        address _token,
        address _recipient,
        uint256 _amount
    ) external onlyOwner {
        if (_token == asset()) revert RescueUnderlying();

        IERC20(_token).transfer(_recipient, _amount);
    }

    /// This is to get incorrectly sent Native currency out of the contract
    /// @param _recipient receiver of the Native currency
    function rescueNative(address _recipient) external onlyOwner {
        uint256 amount = address(this).balance;
        (bool sentAvax, bytes memory _2) = _recipient.call{value: amount}("");
        _2;
        require(sentAvax, "failed to send avax to recipient");
    }

    /// @dev Fallback function to accept Native currency.
    receive() external payable {}
}
