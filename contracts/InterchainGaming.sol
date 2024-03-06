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
    address public lastWinner;

    string[] public uniqueTokens;

    IAxelarGasService public immutable gasService;

    string public winersChainTest;
    string public playerToStringTest;
    string public tokenSymbolTest;
    uint256 public transferAmountTest;

    constructor(
        address _gateway,
        address _gasService
    ) AxelarExecutable(_gateway) {
        gasService = IAxelarGasService(_gasService);
    }

    function guessNumber(
        string memory _destChain,
        string calldata _destContractAddr,
        uint256 _guess,
        string memory _symbol,
        uint256 _amount
    ) external payable {
        require(_guess >= 1 && _guess <= 6, "Guess must be between 1 and 6");

        address tokenAddress = gateway.tokenAddresses(_symbol);

        if (
            bytes(_destChain).length == 0 &&
            bytes(_destContractAddr).length == 0
        ) {
            require(tokenAddress != address(0));

            //send funds to this contract
            IERC20(tokenAddress).transferFrom(
                msg.sender,
                address(this),
                _amount
            );

            _checkIfWinner(
                msg.sender,
                _guess,
                _symbol,
                _amount,
                _destContractAddr
            );
        } else {
            require(msg.value > 0, "Insufficient gas");
            bytes memory encodedBetPayload = abi.encode(msg.sender, _guess);

            //send funds to this contract
            IERC20(tokenAddress).transferFrom(
                msg.sender,
                address(this),
                _amount
            );

            //approve gateway to spend funds
            IERC20(tokenAddress).approve(address(gateway), _amount);

            // call contract with token to send gmp message with token
            gasService.payNativeGasForContractCallWithToken{value: msg.value}(
                address(this),
                _destChain,
                _destContractAddr,
                encodedBetPayload,
                _symbol,
                _amount,
                msg.sender
            );

            gateway.callContractWithToken(
                _destChain,
                _destContractAddr,
                encodedBetPayload,
                _symbol,
                _amount
            );
        }
    }

    function _executeWithToken(
        string calldata _sourceChain,
        string calldata,
        bytes calldata _payload,
        string calldata _symbol,
        uint256 _amount
    ) internal override {
        (address player, uint256 guess) = abi.decode(
            _payload,
            (address, uint256)
        );
        _checkIfWinner(player, guess, _symbol, _amount, _sourceChain);
    }

    function _checkIfWinner(
        address _player,
        uint256 _guess,
        string memory _tokenSymbol,
        uint256 _amount,
        string calldata _bettorsChain
    ) internal {
        _addUniqueTokenSymbol(_tokenSymbol);
        uint256 diceResult = (block.timestamp % 6) + 1;

        bool won = _guess == diceResult;

        lastRoll = diceResult;
        lastBetAmount = _amount;
        lastPlayer = _player;

        if (won) _payOutAllTokensToWinner(_player, _bettorsChain);
    }

    function _addUniqueTokenSymbol(string memory _tokenSymbol) internal {
        bool found = false;

        for (uint256 i = 0; i < uniqueTokens.length; i++) {
            if (
                keccak256(abi.encode(uniqueTokens[i])) ==
                keccak256(abi.encode(_tokenSymbol))
            ) {
                found = true;
                break;
            }
        }
        if (!found) uniqueTokens.push(_tokenSymbol);
    }

    function _payOutAllTokensToWinner(
        address _player,
        string calldata _winnersChain
    ) internal {
        lastWinner = _player;

        for (uint256 i = 0; i < uniqueTokens.length; i++) {
            string memory tokenSymbol = uniqueTokens[i];

            address tokenAddress = gateway.tokenAddresses(tokenSymbol);

            uint256 transferAmount = IERC20(tokenAddress).balanceOf(
                address(this)
            );
            if (bytes(_winnersChain).length == 0) {
                IERC20(tokenAddress).transfer(_player, transferAmount);
            } else {
                IERC20(tokenAddress).approve(address(gateway), 1 ether);

                gateway.callContractWithToken(
                    _winnersChain,
                    _player.toString(),
                    "",
                    tokenSymbol,
                    transferAmount
                );
            }
        }
    }
}
