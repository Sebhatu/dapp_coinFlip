const CoinFlip = artifacts.require("CoinFlip");
const HDWalletProvider = require('truffle-hdwallet-provider');

module.exports = function(deployer,network,accounts) {
  deployer.deploy(CoinFlip);
  
};
