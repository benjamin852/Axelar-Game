// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {AxelarExecutable} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol";
import {IAxelarGateway} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol";
import {IAxelarGasService} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol";
import {AddressToString} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/libs/AddressString.sol";

contract InterchainGaming is AxelarExecutable {
    using AddressToString for address;

    uint256 public lastRoll;
    uint256 public lastBetAmount;
    address public lastPlayer;

    string[] public uniqueTokens;

    IAxelarGasService public immutable gasService;

    constructor(address _gateway, address _gasService) AxelarExecutable(_gateway) {
        gasService = IAxelarGasService(_gasService);
    }

    function guessNumber(
        string memory _destChain,
        string calldata _destContractAddr,
        uint256 _guess,
        string memory _symbol,
        uint256 _amount
    ) external payable {
        //TODO
    }

    function _executeWithToken(
        string calldata _sourceChain,
        string calldata,
        bytes calldata _payload,
        string calldata _symbol,
        uint256 _amount
    ) internal override {
        //TODO
    }

    function _checkIfWinner(
        address _player,
        uint256 _guess,
        string memory _tokenSymbol,
        uint256 _amount,
        string calldata _bettorsChain
    ) internal {
        //TODO
    }

    function _payOutAllTokensToWinner(address _player, string calldata _winnersChain) internal {
        //TODO
    }

    function _addUniqueTokenSymbol(string memory _tokenSymbol) internal {
        //TODO
    }
}
