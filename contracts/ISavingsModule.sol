//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

interface ISavingsModule {
    function deposit(address _protocol, address[] memory _tokens, uint256[] memory _dnAmounts) external returns(uint256);
    function poolTokenByProtocol(address _protocol) external returns (address);
    function withdraw(address _protocol, address token, uint256 dnAmount, uint256 maxNAmount) external returns(uint256);
}