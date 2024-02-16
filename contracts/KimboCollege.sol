// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

//  ▄    ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄   ▄▄▄▄▄▄▄▄▄▄▄                                
// ▐░▌  ▐░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌                               
// ▐░▌ ▐░▌  ▀▀▀▀█░█▀▀▀▀ ▐░▌░▌   ▐░▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌                               
// ▐░▌▐░▌       ▐░▌     ▐░▌▐░▌ ▐░▌▐░▌▐░▌       ▐░▌▐░▌       ▐░▌                               
// ▐░▌░▌        ▐░▌     ▐░▌ ▐░▐░▌ ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌                               
// ▐░░▌         ▐░▌     ▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░▌ ▐░▌       ▐░▌                               
// ▐░▌░▌        ▐░▌     ▐░▌   ▀   ▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░▌       ▐░▌                               
// ▐░▌▐░▌       ▐░▌     ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌       ▐░▌                               
// ▐░▌ ▐░▌  ▄▄▄▄█░█▄▄▄▄ ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌                               
// ▐░▌  ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░▌ ▐░░░░░░░░░░░▌                               
//  ▀    ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀   ▀▀▀▀▀▀▀▀▀▀▀                                
                                                                                           
//  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄            ▄            ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
// ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌          ▐░▌          ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
// ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░▌          ▐░▌          ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ 
// ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌          ▐░▌          ▐░▌          ▐░▌          
// ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌          ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌ ▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ 
// ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌          ▐░░░░░░░░░░░▌▐░▌▐░░░░░░░░▌▐░░░░░░░░░░░▌
// ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌          ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌ ▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ 
// ▐░▌          ▐░▌       ▐░▌▐░▌          ▐░▌          ▐░▌          ▐░▌       ▐░▌▐░▌          
// ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ 
// ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
//  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀ 

// Disclaimer:
// x.com/kimbotrainer
// gKIMBO is a meme coin with no intrinsic value or expectation of financial return. 
// There is no formal team or roadmap. 
// The coin is completely useless and for entertainment purposes only.

// gKimbo will only increase in backing if $Kimbo is added to the Kimbo College contract via an external transfer. 
// This allows for the community to seize opportunities based on their own work to increase the backing of their own tokens. 
// It does not and should not rely solely on the dev.

import {ERC4626Fees, IERC20, ERC4626, ERC20, ERC20Permit, SafeERC20} from "./ERC4626Fees.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title Kimbo College Vault
/// @author @therealbifkn
/// @custom:security-contact @therealbifkn
contract KimboCollege is ERC4626Fees, Ownable(msg.sender) {
    /// @notice address for fees
    address public entryFeeTreasury;
    /// @notice address for transfer fees
    address public transferFeeTreasury;
    /// @notice address for transfer fees
    address public exitFeeTreasury;
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
    /// @param newEntryFeeRecipient new entry fee recipient address
    /// @param newExitFeeRecipient new exit fee recipient address
    /// @param newTransferFeeRecipient new transfer fee recipient address
    event TreasuryUpdated(
        address indexed caller,
        address newEntryFeeRecipient,
        address newExitFeeRecipient,
        address newTransferFeeRecipient
    );

    /// Constructor
    /// @param underlyingAsset Underlying ERC20 asset
    /// @param entryFeeAddress initial address for fee recipient
    /// @param exitFeeAddress initial address for fee recipient
    /// @param transferFeeAddress initial address for fee recipient
    constructor(
        IERC20 underlyingAsset,
        address entryFeeAddress,
        address exitFeeAddress,
        address transferFeeAddress
    )
        ERC4626(underlyingAsset)
        ERC20("Kimbo College", "gKimbo")
        ERC20Permit("Kimbo College")
    {
        require(entryFeeAddress != address(0));
        require(exitFeeAddress != address(0));
        require(transferFeeAddress != address(0));
        entryFeeTreasury = entryFeeAddress;
        exitFeeTreasury = exitFeeAddress;
        transferFeeTreasury = transferFeeAddress;

        /// Exempt treasury for initial distribution to TraderJoe LP
        isTransferFeeExempt[transferFeeAddress] = true;

        emit TreasuryUpdated(
            msg.sender,
            entryFeeAddress,
            exitFeeAddress,
            transferFeeAddress
        );
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

    function _transferFeeRecipient() internal view override returns (address) {
        return transferFeeTreasury;
    }

    function _exitFeeRecipient() internal view override returns (address) {
        return exitFeeTreasury;
    }

    /// Used to set an address exempt from transfer fees
    /// @param addressToChange address to modify the exempt status of
    /// @param isExempt whether or not that address is exempt
    function setTransferFeeExempt(
        address addressToChange,
        bool isExempt
    ) external onlyOwner {
        if (addressToChange == address(0) || addressToChange == BURN_ADDRESS)
            revert InvalidExemptAddress();

        isTransferFeeExempt[addressToChange] = isExempt;
    }

    /// @dev Set fees for entry, exit, and transfer. These all need to be in basis points. e.g. 100 = 1%
    /// @param newEntryFee new fee for deposit/mint
    /// @param newExitFee new fee for redeem/withdraw
    /// @param newTransferFee new fee for transfers
    function setFees(
        uint256 newEntryFee,
        uint256 newExitFee,
        uint256 newTransferFee
    ) external onlyOwner {
        if (newEntryFee > 500 || newExitFee > 500 || newTransferFee > 75)
            revert FeeOutOfRange();

        entryFee = newEntryFee;
        exitFee = newExitFee;
        transferFee = newTransferFee;

        emit FeeUpdated(_msgSender(), newEntryFee, newExitFee, newTransferFee);
    }

    /// Change recipients of the fees
    /// @param newEntryAddress new entry fee recipient
    /// @param newExitAddress new exit fee recipient
    /// @param newTransferAddress new transfer fee recipient
    function setFeeRecipients(
        address newEntryAddress,
        address newExitAddress,
        address newTransferAddress
    ) external onlyOwner {
        if (
            newEntryAddress == address(this) ||
            newExitAddress == address(this) ||
            newTransferAddress == address(this)
        ) revert InvalidFeeRecipient();

        entryFeeTreasury = newEntryAddress;
        exitFeeTreasury = newExitAddress;
        transferFeeTreasury = newTransferAddress;

        emit TreasuryUpdated(
            _msgSender(),
            newEntryAddress,
            newExitAddress,
            newTransferAddress
        );
    }

    /// @dev This is to get incorrectly sent tokens out of the contract
    /// @param token token contract of the tokens to be withdrawn
    /// @param recipient address to transfer to
    /// @param amount amount to withdraw
    function rescueToken(
        address token,
        address recipient,
        uint256 amount
    ) external onlyOwner {
        if (token == asset()) revert RescueUnderlying();

        SafeERC20.safeTransfer(IERC20(token), recipient, amount);
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
