const testGas = require("@gnosis.pm/truffle-nice-tools").testGas;
const ethUtils = require('ethereumjs-util');

const DecentralizedIntegerPushOracle = artifacts.require("DecentralizedIntegerPushOracle");
const DecentralizedPushOracleConsumer = artifacts.require("DecentralizedPushOracleConsumer");

let contracts = [DecentralizedPushOracleConsumer, DecentralizedIntegerPushOracle];

contract("DecentralizedPushOracleConsumer", (accounts) => {
  let _DecentralizedPushOracleConsumer;
  let _DecentralizedIntegerPushOracle;
  before(testGas.createGasStatCollectorBeforeHook(contracts));
  after(testGas.createGasStatCollectorAfterHook(contracts));

  before(async () => {
    _DecentralizedIntegerPushOracle = await DecentralizedIntegerPushOracle.deployed();
    _DecentralizedPushOracleConsumer = await DecentralizedPushOracleConsumer.new(_DecentralizedIntegerPushOracle.address);
  })

  it("Should have an oracle set correctly at creation", async () => {
    assert.equal(await _DecentralizedPushOracleConsumer.oracle(), _DecentralizedIntegerPushOracle.address);
  });
});

contract("DecentralizedIntegerPushOracle", (accounts) => {
  let _DecentralizedPushOracleConsumer;
  let _DecentralizedIntegerPushOracle;

  before(async () => {
    _DecentralizedIntegerPushOracle = await DecentralizedIntegerPushOracle.deployed();
    _DecentralizedPushOracleConsumer = await DecentralizedPushOracleConsumer.new(_DecentralizedIntegerPushOracle.address);
  });

  before(testGas.createGasStatCollectorBeforeHook(contracts));
  after(testGas.createGasStatCollectorAfterHook(contracts));


  it("Should be able to set the results correctly using inputData", async () => {
      for (var i=0; i<50; i++) {
        _DecentralizedIntegerPushOracle.inputData(i, {
          from: accounts[i]
        })
      }
      assert.equal(await _DecentralizedIntegerPushOracle.integerReports(49).then(res => res.toString(10)), 49);
  })

  it("Should be able to send results to the OracleConsumer correctly", async () => {
    await _DecentralizedIntegerPushOracle.pushInteger(_DecentralizedPushOracleConsumer.address);

    assert.equal(await _DecentralizedPushOracleConsumer.resolution(), ethUtils.bufferToHex(ethUtils.setLengthLeft(24, 32)));
  });

})