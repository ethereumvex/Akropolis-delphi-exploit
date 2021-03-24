//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

interface ICurveFiProtocol_Y {
    function balanceOf(address account) external view returns (uint256);

    function normalizedBalance() external returns(uint256);
    //     uint256[] memory balances = balanceOfAll();
    //     uint256 summ;
    //     for (uint256 i=0; i < _registeredTokens.length; i++){
    //         summ = summ.add(normalizeAmount(_registeredTokens[i], balances[i]));
    //     }
    //     return summ;
    // }
}