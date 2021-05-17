const CoinFlip = artifacts.require("CoinFlip");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(CoinFlip).then(function(instance) {
     console.log("Network accounts - accounts[0] -- " +accounts[0]);
     instance.depositeContractBalance({value : web3.utils.toWei("5", "ether"), from: accounts[0]}).then(function(balance) {
       console.log("contractBalance - "+balance.toString());
     })

     let contractBalance = instance.getContractBalance();
     console.log("contract balance" + contractBalance.toString());

     instance.placeBetAndFlip(1, {value: web3.utils.toWei("1", "ether"), from: accounts[1]}).then(function(receipt) {
       console.log("Bet placed - "+ receipt);
       let randomNumber = instance.getRandomNumber();
       let coinState = instance.getCoinState();

       console.log("Random number - "+randomNumber.toString());
       console.log("Coin state - "+coinState.toString());

     }).catch(function(err) {
       console.log("Bet did not get through");
     })
 });
}
///Users/harsh/CryptoDev/IvanAcademy/EthereumAdvancedProgramming201/coinFlip
