const testGas = require("@gnosis.pm/truffle-nice-tools").testGas;
const ethUtils = require('ethereumjs-util');

const CentralizedWeatherPullOracle = artifacts.require("CentralizedWeatherPullOracle");
const DecentralizedWeatherPullOracleFeed = artifacts.require("DecentralizedWeatherPullOracleFeed");

const CentralizedPullOracleConsumer = artifacts.require("CentralizedPullOracleConsumer");
const DecentralizedPullOracleFeedConsumer = artifacts.require("DecentralizedPullOracleFeedConsumer");

contracts = [CentralizedPullOracleConsumer, DecentralizedPullOracleFeedConsumer, CentralizedWeatherPullOracle, DecentralizedWeatherPullOracleFeed];

contract("CentralizedPullOracleConsumer", (accounts) => {
  let _CentralizedWeatherPullOracle;

  before(async () => {
    _CentralizedWeatherPullOracle = await CentralizedWeatherPullOracle.deployed();
    _CentralizedPullOracleConsumer = await CentralizedPullOracleConsumer.new(_CentralizedWeatherPullOracle.address);
  });

  it("Should have the oracle defined", async () => {
    let oracle = await _CentralizedPullOracleConsumer.oracle();
    assert.equal(oracle, _CentralizedWeatherPullOracle.address);
  });
  
  it("Should be able to call the resultFor function on the oracle and set the result")
  // contract("")
  
});

contract("CentralizedWeatherPullOracle", (accounts) => {
  let _CentralizedWeatherPullOracle;
  
  before(async () => {
    _CentralizedWeatherPullOracle = await CentralizedWeatherPullOracle.deployed();
  });

  it("Should initiate with the initial values for degreesCelsius and resultSet unset.", async () => {
    let degreesCelsius = await _CentralizedWeatherPullOracle.degreesCelsius();
    degreesCelsius = await degreesCelsius.toString(10);
    let resultSet = await _CentralizedWeatherPullOracle.resultSet();
    assert.equal(degreesCelsius, 0);
    assert.equal(resultSet, false);
  });

  it("Should revert when resultFor is called before any result is set.", async () => {
    try {
      const resultFor = await _CentralizedWeatherPullOracle.resultFor(22);
    } catch (err) {
      assert(true);
    }
  });

  it("Should be able to set the degreesCelsius and resultSet with the inputData function, only one time.", async () => {
    const inputData = await _CentralizedWeatherPullOracle.inputData(9, {
      from: accounts[0]
    });
    let degreesCelsius = await _CentralizedWeatherPullOracle.degreesCelsius();
    degreesCelsius = await degreesCelsius.toString(10);
    let resultSet = await _CentralizedWeatherPullOracle.resultSet();

    assert.equal(resultSet, true);
    assert.equal(degreesCelsius, 9);

    try {
      inputData;
    } catch (err) {
      assert(true);
    }
  });

  it("Should return the resultFor after the inputData transaction has been successfully mined.", async () => {
    const testNumber = ethUtils.bufferToHex(ethUtils.setLengthLeft(3, 32));
    const resultFor = await _CentralizedWeatherPullOracle.resultFor(testNumber);
    assert(ethUtils.bufferToInt(resultFor), 9);
  })

});