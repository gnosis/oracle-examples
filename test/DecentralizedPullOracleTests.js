const testGas = require("@gnosis.pm/truffle-nice-tools").testGas;
const ethUtils = require('ethereumjs-util');

const DecentralizedIntegerPullOracleFeed = artifacts.require("DecentralizedIntegerPullOracleFeed");
const DecentralizedPullOracleFeedConsumer = artifacts.require("DecentralizedPullOracleFeedConsumer");

let contracts = [DecentralizedPullOracleFeedConsumer, DecentralizedIntegerPullOracleFeed];


contract("DecentralizedPullOracleFeedConsumer", (accounts) => {
  let _DecentralizedIntegerPullOracleFeed;
  let _DecentralizedPullOracleFeedConsumer;

  before(async () => {
    _DecentralizedIntegerPullOracleFeed = await DecentralizedIntegerPullOracleFeed.deployed();
    _DecentralizedPullOracleFeedConsumer = await DecentralizedPullOracleFeedConsumer.new(_DecentralizedIntegerPullOracleFeed.address);
  });

  before(testGas.createGasStatCollectorBeforeHook(contracts));
  after(testGas.createGasStatCollectorAfterHook(contracts));

  it("Should have the oracle defined", async () => {
    let oracle = await _DecentralizedPullOracleFeedConsumer.oracle();
    assert.equal(oracle, _DecentralizedIntegerPullOracleFeed.address);
  });

  it("Should revert if the oracle.resultFor() function is called before the any reports are set.", async () => {
    try {
      await _DecentralizedPullOracleFeedConsumer.getResult(ethUtils.bufferToHex(ethUtils.setLengthLeft(0, 32)));
    } catch (err) {
      assert(true);
    }
  });

  it("Should be able to call the resultFor function on the oracle and set the result", async () => {
    await _DecentralizedIntegerPullOracleFeed.inputData(9, {
      from: accounts[0]
    });
  
    await _DecentralizedPullOracleFeedConsumer.getResult(0);
    assert.equal(await _DecentralizedPullOracleFeedConsumer.resolution(0).then(res => res.toString(10)), 9); 
  });
});

contract("DecentralizedIntegerPullOracleFeed", (accounts) => {
  let _DecentralizedIntegerPullOracleFeed;
  
  before(async () => {
    _DecentralizedIntegerPullOracleFeed = await DecentralizedIntegerPullOracleFeed.new();
  });

  before(testGas.createGasStatCollectorBeforeHook(contracts));
  after(testGas.createGasStatCollectorAfterHook(contracts));

  it("Should not allow the same reporter to input two times.", async () => {
    try {
      await _DecentralizedIntegerPullOracleFeed.inputData(9, {
        from: accounts[0]
      });
      await _DecentralizedIntegerPullOracleFeed.inputData(11, {
        from: accounts[0]
      });
    } catch (err) {
      assert(true);
    }
  })

  it("Expect inputData function to input data into integerReports and change the running average", async () => {
    let inputData = _DecentralizedIntegerPullOracleFeed.inputData(13, {
      from: accounts[1]
    });

    assert.equal(await _DecentralizedIntegerPullOracleFeed.integerReports(1).then(res => res.toString(10)), 11);
    assert.equal(await _DecentralizedIntegerPullOracleFeed.runningAverage(1).then(res => res.toString(10)), 10);
  });
});