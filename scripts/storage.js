const { ethers } = require("hardhat");
// const { IERC20 } = require("@openzeppelin/contracts/token/ERC20");
const hre = require("hardhat");
const [addresses, forkFrom, impersonate, readStorage] = require('../utils/utils.js');

async function main() {
    

await readStorage(12, '0xe2307837524db8961c4541f943598654240bd62f');

// get the signer for sending the transaction:
// impersonate(addresses.exploiter);
// const attacker = ethers.provider.getSigner(addresses.SavingsModule);

// token = await ethers.getContractAt("IUniswapV2ERC20", addresses.MaliciousToken);


// const amountToken = await token.connect(attacker).callStatic.balanceOf(addresses.exploiter);

// console.log(amountToken);

}


main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });