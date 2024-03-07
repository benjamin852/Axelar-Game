// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {AxelarExecutable} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol";
import {IAxelarGateway} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol";
import {IAxelarGasService} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol";

contract InterchainGameReceiver is AxelarExecutable {
    string[] public uniqueTokens;

    IAxelarGasService public immutable gasService;

    constructor(address _gateway, address _gasService) AxelarExecutable(_gateway) {
        gasService = IAxelarGasService(_gasService);
    }

    function _executeWithToken(
        string calldata _sourceChain,
        string calldata _sourceAddress,
        bytes calldata _payload,
        string calldata _symbol,
        uint256
    ) internal override {
        // TODO
    }

    function _checkIfWinner(
        bytes calldata _payload,
        string memory _tokenSymbol,
        string calldata _sourceAddress,
        string calldata _sourceChain
    ) internal {
        //TODO
    }

    function _addUniqueTokenSymbol(string memory _tokenSymbol) internal {
        //TODO
    }

    function _payOutAllTokensToWinner(
        address _player,
        string calldata _sourceAddress,
        string calldata _winnersChain
    ) internal {
        //TODO
    }
}
