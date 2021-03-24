const hre = require("hardhat");
// from: https://github.com/MrToph/replaying-ethereum-hacks/blob/master/test/utils/fork.ts
const forkFrom = async (blockNumber) => {  
    await hre.network.provider.request({
      method: "hardhat_reset",
      params: [
        {
          forking: {
            jsonRpcUrl: hre.config.networks.hardhat.forking.url,
            blockNumber: blockNumber,
          },
        },
      ],
    });
};

const addresses = {
    SavingsModule: "0x73fc3038b4cd8ffd07482b92a52ea806505e5748",
    exploiter: "0x9f26ae5cd245bfeeb5926d61497550f79d9c6c1c",
    dai: "0x6b175474e89094c44da98b954eedeac495271d0f",
    AkroYPool: "0x7967ada2a32a633d5c055e2e075a83023b632b4e",
    dyPool: "0x2afa3c8bf33e65d5036cd0f1c3599716894b3077", 
}

const impersonate = async function getImpersonatedSigner(address) {
    await hre.network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [address]
    });
    return ethers.provider.getSigner(address);
}

const readStorage = async (n, address) => {

  for(i = 0; i<n; i++) {
      const t = await ethers.provider.getStorageAt(address, i);
      console.log(i+': '+t);

  }

}

module.exports = [addresses, forkFrom, impersonate, readStorage];