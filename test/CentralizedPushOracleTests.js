const testGas = require("@gnosis.pm/truffle-nice-tools").testGas;
const ethUtils = require('ethereumjs-util');

const CentralizedIntegerPushOracle = artifacts.require("CentralizedIntegerPushOracle");
const CentralizedPushOracleConsumer = artifacts.require("CentralizedPushOracleConsumer");

let contracts = [CentralizedIntegerPushOracle,CentralizedPushOracleConsumer];

contract("CentralizedPushOracleConsumer", (accounts) => {
  let zeroHex = ethUtils.bufferToHex(ethUtils.setLengthLeft(0, 32));
  let _CentralizedIntegerPushOracle;
  let _CentralizedPushOracleConsumer;

  before(async () => {
    _CentralizedIntegerPushOracle = await CentralizedIntegerPushOracle.deployed();
    _CentralizedPushOracleConsumer = await CentralizedPushOracleConsumer.new(_CentralizedIntegerPushOracle.address);
  });

  before(testGas.createGasStatCollectorBeforeHook(contracts));
  after(testGas.createGasStatCollectorAfterHook(contracts));

  it("Should be initialized with the correct oracle", async () => {
    let oracle = await _CentralizedPushOracleConsumer.oracle();
    assert.equal(oracle, CentralizedIntegerPushOracle.address);
  })    

  it("Should revert calls from anything that isn't an authorized oracle.", async() => {
    try {
      let invalidCall = await _CentralizedPushOracleConsumer.receiveResult(zeroHex, zeroHex, {
        from: accounts[2]
      })
    } catch (err) {
      assert(true);
    }
  });

});

contract("CentralizedIntegerPushOracle", (accounts) => {
  let _CentralizedIntegerPushOracle;

  before(async () => {
    _CentralizedIntegerPushOracle = await CentralizedIntegerPushOracle.deployed();
    _CentralizedPushOracleConsumer = await CentralizedPushOracleConsumer.new(_CentralizedIntegerPushOracle.address);
  });

  before(testGas.createGasStatCollectorBeforeHook(contracts));
  after(testGas.createGasStatCollectorAfterHook(contracts));

  it("Should push results to the OracleConsumer", async () => {
    _CentralizedIntegerPushOracle.pushInteger(_CentralizedPushOracleConsumer.address, 9);
    assert.equal(await _CentralizedPushOracleConsumer.resolution().then(res => res.toString(10)), 9);
  });
});