const CentralizedIntegerPullOracle = artifacts.require('./CentralizedIntegerPullOracle.sol');
const CentralizedIntegerPullFeedOracle = artifacts.require('./CentralizedIntegerPullFeedOracle.sol');
const DecentralizedIntegerPullOracle = artifacts.require('./DecentralizedIntegerPullOracle.sol');
const DecentralizedIntegerPullOracleFeed = artifacts.require('./DecentralizedIntegerPullOracleFeed.sol');

const CentralizedIntegerPushOracle = artifacts.require('./CentralizedIntegerPushOracle.sol');
const CentralizedIntegerPushFeedOracle = artifacts.require('./CentralizedIntegerPushFeedOracle.sol');
const DecentralizedIntegerPushOracle = artifacts.require('./DecentralizedIntegerPushOracle.sol');
const DecentralizedIntegerPushOracleFeed = artifacts.require('./DecentralizedIntegerPushOracleFeed.sol');

module.exports = function(deployer, network, accounts) {
  if (network == "test" || network == "ganache") {
    deployer.deploy(CentralizedIntegerPullOracle);
    deployer.deploy(CentralizedIntegerPullFeedOracle);
    deployer.deploy(DecentralizedIntegerPullOracle, 50);
    deployer.deploy(DecentralizedIntegerPullOracleFeed);
    deployer.deploy(CentralizedIntegerPushOracle);
    deployer.deploy(CentralizedIntegerPushFeedOracle);
    deployer.deploy(DecentralizedIntegerPushOracle, 50);
    deployer.deploy(DecentralizedIntegerPushOracleFeed);
  }
};
