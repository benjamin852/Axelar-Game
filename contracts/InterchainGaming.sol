// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {AxelarExecutable} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/executable/AxelarExecutable.sol";
import {IAxelarGateway} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol";
import {IAxelarGasService} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol";

contract InterchainGaming is AxelarExecutable {
    IAxelarGasService public immutable gasService;

    address public gameReceiver;

    string[] public uniqueTokens;

    constructor(address _gateway, address _gasService, address _gameReceiver) AxelarExecutable(_gateway) {
        gasService = IAxelarGasService(_gasService);
        gameReceiver = _gameReceiver;
    }

    /**
     *
     * @param _destChain what chain are we going to
     * @param _destContractAddr what address on the destination chain are we going to
     * @param _guess what is our guess
     * @param _symbol what is our token symbol we're staking
     * @param _amount what is the amount of the token were staking
     */
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

    function _checkIfWinner(address _player, uint256 _guess, string memory _tokenSymbol, uint256 _amount) internal {
        _addUniqueTokenSymbol(_tokenSymbol);
        // uint256 diceResult = (block.timestamp % 6) + 1;
        uint256 diceResult = 5;

        bool won = _guess == diceResult;

        if (won) _payOutAllTokensToWinner(_player);
    }

    function _payOutAllTokensToWinner(address _player) internal {
        for (uint i = 0; i < uniqueTokens.length; i++) {
            string memory tokenSymbol = uniqueTokens[i];
            address tokenAddress = gateway.tokenAddresses(tokenSymbol);
            uint256 transferAmount = IERC20(tokenAddress).balanceOf(address(this));
            IERC20(tokenAddress).transfer(_player, transferAmount);
        }
    }

    function _addUniqueTokenSymbol(string memory _tokenSymbol) internal {
        bool found = false;

        for (uint256 i = 0; i < uniqueTokens.length; i++) {
            if (keccak256(abi.encode(uniqueTokens[i])) == keccak256(abi.encode(_tokenSymbol))) {
                found = true;
                break;
            }
        }
        if (!found) uniqueTokens.push(_tokenSymbol);
    }
}
