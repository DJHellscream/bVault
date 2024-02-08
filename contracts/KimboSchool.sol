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

import "./ERC4626Fees.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract KimboSchool is ERC4626Fees, Ownable(msg.sender) {
    address payable public entryFeeTreasury;
    address payable public exitFeeTreasury;
    address payable public transferFeeTreasury;
    uint256 public entryFeeBasisPoints = 500;
    uint256 public exitFeeBasisPoints = 100;
    uint256 public transferFeeBasisPoints = 100;

    error FeeOutOfBounds();

    event FeeUpdated(uint256 newFee);
    event TreasuryUpdated(address newAddress);

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
        uint256 _newFeeBasisPoints
    ) external onlyOwner {
        if (_newFeeBasisPoints < 0 || _newFeeBasisPoints > 500)
            revert FeeOutOfBounds();

        entryFeeBasisPoints = _newFeeBasisPoints;

        emit FeeUpdated(_newFeeBasisPoints);
    }

    function setExitFeeBasisPoints(
        uint256 _newFeeBasisPoints
    ) external onlyOwner {
        if (_newFeeBasisPoints < 0 || _newFeeBasisPoints > 500)
            revert FeeOutOfBounds();

        exitFeeBasisPoints = _newFeeBasisPoints;

        emit FeeUpdated(_newFeeBasisPoints);
    }

    function setTransferFeeBasisPoints(
        uint256 _newFeeBasisPoints
    ) external onlyOwner {
        if (_newFeeBasisPoints < 0 || _newFeeBasisPoints > 500)
            revert FeeOutOfBounds();

        transferFeeBasisPoints = _newFeeBasisPoints;

        emit FeeUpdated(_newFeeBasisPoints);
    }

    function setEntryFeeRecipient(
        address entryFeeRecipient
    ) external onlyOwner {
        entryFeeTreasury = payable(entryFeeRecipient);

        emit TreasuryUpdated(entryFeeRecipient);
    }

    function setExitFeeRecipient(address exitFeeRecipient) external onlyOwner {
        exitFeeTreasury = payable(exitFeeRecipient);

        emit TreasuryUpdated(exitFeeRecipient);
    }

    function setTransferFeeRecipient(
        address transferFeeRecipient
    ) external onlyOwner {
        transferFeeTreasury = payable(transferFeeRecipient);

        emit TreasuryUpdated(transferFeeRecipient);
    }
}
