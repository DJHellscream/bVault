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

import "./ERC4626Fees.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title Kimbo School Vault
/// @author @therealbifkn
/// @custom:security-contact @therealbifkn
contract KimboSchool is ERC4626Fees, Ownable(msg.sender) {
    address payable public entryFeeTreasury;
    address payable public exitFeeTreasury;
    address payable public transferFeeTreasury;
    uint256 public entryFeeBasisPoints = 500;
    uint256 public exitFeeBasisPoints = 100;
    uint256 public transferFeeBasisPoints = 50;

    // Errors
    error FeeOutOfBounds();
    error InvalidFeeRecipient();

    // Events
    event FeeUpdated(address indexed caller, uint256 newFee);
    event TreasuryUpdated(address indexed caller, address newAddress);

    ///
    /// @param _asset Underlying ERC20 asset
    /// @param treasuryAddress initial address for fee recipient
    constructor(
        IERC20 _asset,
        address treasuryAddress
    ) ERC4626(_asset) ERC20("Kimbo School", "tKimbo") {
        entryFeeTreasury = payable(treasuryAddress);
        exitFeeTreasury = payable(treasuryAddress);
        transferFeeTreasury = payable(treasuryAddress);
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

    ///
    /// @param _newFeeBasisPoints set Entry Fee to new Basis Point
    function setEntryFee(uint256 _newFeeBasisPoints) external onlyOwner {
        if (_newFeeBasisPoints < 0 || _newFeeBasisPoints > 500)
            revert FeeOutOfBounds();

        entryFeeBasisPoints = _newFeeBasisPoints;

        emit FeeUpdated(msg.sender, _newFeeBasisPoints);
    }

    ///
    /// @param _newFeeBasisPoints set Exit Fee to new Basis Point
    function setExitFee(uint256 _newFeeBasisPoints) external onlyOwner {
        if (_newFeeBasisPoints < 0 || _newFeeBasisPoints > 500)
            revert FeeOutOfBounds();

        exitFeeBasisPoints = _newFeeBasisPoints;

        emit FeeUpdated(msg.sender, _newFeeBasisPoints);
    }

    ///
    /// @param _newFeeBasisPoints set Transfer Fee to new Basis Point
    function setTransferFee(uint256 _newFeeBasisPoints) external onlyOwner {
        if (_newFeeBasisPoints < 0 || _newFeeBasisPoints > 500)
            revert FeeOutOfBounds();

        transferFeeBasisPoints = _newFeeBasisPoints;

        emit FeeUpdated(msg.sender, _newFeeBasisPoints);
    }

    ///
    /// @param feeRecipient set Entry Fee Recipient
    function setEntryFeeRecipient(address feeRecipient) external onlyOwner {
        if (feeRecipient == address(this)) revert InvalidFeeRecipient();

        entryFeeTreasury = payable(feeRecipient);

        emit TreasuryUpdated(msg.sender, feeRecipient);
    }

    ///
    /// @param feeRecipient set Exit Fee Recipient
    function setExitFeeRecipient(address feeRecipient) external onlyOwner {
        if (feeRecipient == address(this)) revert InvalidFeeRecipient();
        exitFeeTreasury = payable(feeRecipient);

        emit TreasuryUpdated(msg.sender, feeRecipient);
    }

    ///
    /// @param feeRecipient set Transfer Fee Recipient
    function setTransferFeeRecipient(address feeRecipient) external onlyOwner {
        if (feeRecipient == address(this)) revert InvalidFeeRecipient();
        transferFeeTreasury = payable(feeRecipient);

        emit TreasuryUpdated(msg.sender, feeRecipient);
    }

    /// This is to get incorrectly sent tokens out of the contract
    /// @param _token token contract of the tokens to be withdrawn
    /// @param _recipient address to transfer to
    /// @param _amount amount to withdraw
    function withdrawToken(
        address _token,
        address _recipient,
        uint256 _amount
    ) external onlyOwner {
        require(_token != asset(), "Underlying");

        IERC20 tokenContract = IERC20(_token);
        tokenContract.transfer(_recipient, _amount);
    }

    /// This is to get incorrectly sent Native currency out of the contract
    /// @param _recipient receiver of the Native currency
    function withdrawNative(address _recipient) external onlyOwner {
        uint256 amount = address(this).balance;
        payable(_recipient).transfer(amount);
    }

    // Fallback function to accept Native currency.
    receive() external payable {}
}
