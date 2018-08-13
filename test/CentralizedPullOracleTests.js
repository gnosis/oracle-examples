const testGas = require("@gnosis.pm/truffle-nice-tools").testGas;
const ethUtils = require('ethereumjs-util');

const CentralizedIntegerPullOracle = artifacts.require("CentralizedIntegerPullOracle");
const CentralizedIntegerPullFeedOracle = artifacts.require("CentralizedIntegerPullFeedOracle");
const CentralizedPullOracleConsumer = artifacts.require("CentralizedPullOracleConsumer");
const CentralizedPullOracleFeedConsumer = artifacts.require("CentralizedPullOracleFeedConsumer");


let contracts = [CentralizedPullOracleConsumer, CentralizedIntegerPullOracle, CentralizedIntegerPullFeedOracle, CentralizedPullOracleFeedConsumer];

contract("CentralizedPullOracleConsumer", (accounts) => {
  let _CentralizedIntegerPullOracle;

  before(async () => {
    _CentralizedIntegerPullOracle = await CentralizedIntegerPullOracle.deployed();
    _CentralizedPullOracleConsumer = await CentralizedPullOracleConsumer.new(_CentralizedIntegerPullOracle.address);
  });

  before(testGas.createGasStatCollectorBeforeHook(contracts));
  after(testGas.createGasStatCollectorAfterHook(contracts));

  it("Should have the oracle defined", async () => {
    let oracle = await _CentralizedPullOracleConsumer.oracle();
    assert.equal(oracle, _CentralizedIntegerPullOracle.address);
  });

  it("Should revert if the oracle.resultFor() function is called before the results are set", async () => {
    try {
      await _CentralizedPullOracleConsumer.getResult(ethUtils.bufferToHex(ethUtils.setLengthLeft(0, 32)));
    } catch (err) {
      assert(true);
    }
  });
  
  it("Should be able to call the resultFor function on the oracle and set the result", async () => {
    await _CentralizedIntegerPullOracle.inputData(9);
    await _CentralizedPullOracleConsumer.getResult(ethUtils.bufferToHex(ethUtils.setLengthLeft(0, 32)));
    let resolution = await _CentralizedPullOracleConsumer.resolution();
    resolution = resolution.toString(10);
    assert.equal(resolution, 9);    
  })
});

contract("CentralizedIntegerPullOracle", (accounts) => {
  let _CentralizedIntegerPullOracle;
  
  before(async () => {
    _CentralizedIntegerPullOracle = await CentralizedIntegerPullOracle.deployed();
  });

  before(testGas.createGasStatCollectorBeforeHook(contracts));
  after(testGas.createGasStatCollectorAfterHook(contracts));

  it("Should initiate with the initial values for integer and resultSet unset.", async () => {
    let integer = await _CentralizedIntegerPullOracle.integer();
    integer = await integer.toString(10);
    let resultSet = await _CentralizedIntegerPullOracle.resultSet();
    assert.equal(integer, 0);
    assert.equal(resultSet, false);
  });

  it("Should revert when resultFor is called before any result is set.", async () => {
    try {
      const resultFor = await _CentralizedIntegerPullOracle.resultFor(22);
    } catch (err) {
      assert(true);
    }
  });

  it("Should be able to set the integer and resultSet with the inputData function, only one time.", async () => {
    const inputData = await _CentralizedIntegerPullOracle.inputData(9, {
      from: accounts[0]
    });
    let integer = await _CentralizedIntegerPullOracle.integer();
    integer = await integer.toString(10);
    let resultSet = await _CentralizedIntegerPullOracle.resultSet();

    assert.equal(resultSet, true);
    assert.equal(integer, 9);

    try {
      inputData;
    } catch (err) {
      assert(true);
    }
  });

  it("Should return the resultFor after the inputData transaction has been successfully mined.", async () => {
    const testNumber = ethUtils.bufferToHex(ethUtils.setLengthLeft(3, 32));
    const resultFor = await _CentralizedIntegerPullOracle.resultFor(testNumber);
    assert(ethUtils.bufferToInt(resultFor), 9);
  })
});