// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (finance/PaymentSplitter.sol)

pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/prebuilts/split/Split.sol";

/// @title FeeSplitter for Kimbo
/// @author @therealbifkn
/// @notice This is a version of Split.sol from Thirdweb but is modified to prevent public call of distributing/releasing the Native currency.
/// @notice Only $KIMBO should be distributed to the shareholders. Avax is simply in the contract to cover fees
/// @notice Native can only be released by the default_admin
contract KimboSplitter is Split {
    /// Release native currency
    /// This is here in the event where a new payment splitter contract is deployed
    /// Otherwise Avax would be stuck
    function releaseNative() external onlyRole(DEFAULT_ADMIN_ROLE) {
        uint256 amount = address(this).balance;
        (bool _1, bytes memory _2) = _msgSender().call{value: amount}("");
        _1;
        _2;
    }

    /// Prevent distribution of native by public
    function distribute() public virtual override onlyRole(DEFAULT_ADMIN_ROLE) {
        uint256 count = payeeCount();
        for (uint256 i = 0; i < count; i++) {
            _release(payable(payee(i)));
        }
    }

    /// Prevent release of native by public
    /// @param account account to release native to
    function release(
        address payable account
    ) public virtual override onlyRole(DEFAULT_ADMIN_ROLE) {
        uint256 payment = _release(account);
        require(payment != 0, "PaymentSplitter: account is not due payment");
    }
}
