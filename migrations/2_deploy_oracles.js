const DifficultyOracle = artifacts.require("./DifficultyOracle.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(DifficultyOracle, "2730945")
  .then(data => {
    console.log(`Successful Deployment of DifficultyOracle`);
  })
  .catch(err => {
    console.log(`Problem with deployment: ${err}`);
  });
  deployer.deploy(ParityWalletOracle)
  .then(data => {
    console.log(`Successful Deployment of ParityWalletOracle`);
  })
  .catch(err => {
    console.log(`Problem with deployment: ${err}`);
  });
};
