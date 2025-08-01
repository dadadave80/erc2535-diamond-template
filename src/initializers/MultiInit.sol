// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {LibDiamond} from "@diamond/libraries/LibDiamond.sol";
import {AddressAndCalldataLengthDoNotMatch} from "@diamond/libraries/errors/DiamondErrors.sol";

/// @notice Executes multiple initialization calls in sequence during a diamond upgrade
/// @author David Dada
/// @author Modified from Timo (https://github.com/FydeTreasury/Diamond-Foundry/blob/main/src/upgradeInitializers/DiamondMultiInit.sol)
///
/// @dev Useful when a diamond cut requires initializing several facets at once
contract MultiInit {
    /// @notice Performs multiple initialization calls to provided addresses with corresponding calldata
    /// @dev Reverts if `_addresses.length != _calldata.length`. Each address is called via delegatecall using LibDiamond._initializeDiamondCut.
    /// @param _addresses The list of initializer contract addresses
    /// @param _calldata The list of encoded function calls for each initializer
    function multiInit(address[] calldata _addresses, bytes[] calldata _calldata) external {
        uint256 addressesLength = _addresses.length;
        if (addressesLength != _calldata.length) {
            revert AddressAndCalldataLengthDoNotMatch();
        }
        for (uint256 i; i < addressesLength; ++i) {
            LibDiamond._initializeDiamondCut(_addresses[i], _calldata[i]);
        }
    }
}
