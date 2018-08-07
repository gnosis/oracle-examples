const CentralizedWeatherPullOracle = artifacts.require('./CentralizedWeatherPullOracle.sol');
const CentralizedWeatherPullFeedOracle = artifacts.require('./CentralizedWeatherPullFeedOracle.sol');
const DecentralizedWeatherPullOracle = artifacts.require('./DecentralizedWeatherPullOracle.sol');
const DecentralizedWeatherPullOracleFeed = artifacts.require('./DecentralizedWeatherPullOracleFeed.sol');

const CentralizedWeatherPushOracle = artifacts.require('./CentralizedWeatherPushOracle.sol');
const CentralizedWeatherPushFeedOracle = artifacts.require('./CentralizedWeatherPushFeedOracle.sol');
const DecentralizedWeatherPushOracle = artifacts.require('./DecentralizedWeatherPushOracle.sol');
const DecentralizedWeatherPushOracleFeed = artifacts.require('./DecentralizedWeatherPushOracleFeed.sol');

module.exports = function(deployer, network, accounts) {
  if (network == "test" || network == "ganache") {
    deployer.deploy(CentralizedWeatherPullOracle);
    deployer.deploy(CentralizedWeatherPullFeedOracle);
    // deployer.deploy(DecentralizedWeatherPullOracle, 50);
    deployer.deploy(DecentralizedWeatherPullOracleFeed, 50);
    deployer.deploy(CentralizedWeatherPushOracle);
    deployer.deploy(CentralizedWeatherPushFeedOracle);
    deployer.deploy(DecentralizedWeatherPushOracle, 50);
    deployer.deploy(DecentralizedWeatherPushOracleFeed, 50);
  }
};
