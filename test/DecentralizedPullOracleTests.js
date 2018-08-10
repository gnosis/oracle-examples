const testGas = require("@gnosis.pm/truffle-nice-tools").testGas;
const ethUtils = require('ethereumjs-util');

const DecentralizedWeatherPullOracleFeed = artifacts.require("DecentralizedWeatherPullOracleFeed");
const DecentralizedPullOracleFeedConsumer = artifacts.require("DecentralizedPullOracleFeedConsumer");

let contracts = [DecentralizedPullOracleFeedConsumer, DecentralizedWeatherPullOracleFeed];


contract("DecentralizedPullOracleFeedConsumer", (accounts) => {
  let _DecentralizedWeatherPullOracleFeed;
  let _DecentralizedPullOracleFeedConsumer;

  before(async () => {
    _DecentralizedWeatherPullOracleFeed = await DecentralizedWeatherPullOracleFeed.deployed();
    _DecentralizedPullOracleFeedConsumer = await DecentralizedPullOracleFeedConsumer.new(_DecentralizedWeatherPullOracleFeed.address);
  });

  before(testGas.createGasStatCollectorBeforeHook(contracts));
  after(testGas.createGasStatCollectorAfterHook(contracts));

  it("Should have the oracle defined", async () => {
    let oracle = await _DecentralizedPullOracleFeedConsumer.oracle();
    assert.equal(oracle, _DecentralizedWeatherPullOracleFeed.address);
  });

  it("Should increment totalReports", async () => {
    await _DecentralizedWeatherPullOracleFeed.inputData(9, {
      from: accounts[2]
    });
    let totalReports = await _DecentralizedWeatherPullOracleFeed.totalReports()
    totalReports = totalReports.toString(10);
    assert.equal(totalReports, 1);
  });
  
  it("Should revert if the oracle.resultFor() function is called before the totalReports are set.", async () => {
    try {
      await _DecentralizedWeatherPullOracleFeed.inputData(9, {
        from: accounts[0]
      });
      await _DecentralizedPullOracleFeedConsumer.getResult(ethUtils.bufferToHex(ethUtils.setLengthLeft(0, 32)));
    } catch (err) {
      assert(true);
    }
  });

  it("Should be able to call the resultFor function on the oracle and set the result", async () => {
    var currentDate = new Date().getUTCDate();
    currentDate = ethUtils.bufferToHex(ethUtils.setLengthLeft(currentDate, 32));

    for (var i=3; i<=50; i++) {
      await _DecentralizedWeatherPullOracleFeed.inputData(9, {
        from: accounts[i]
      });
    }
    let totalReports = await _DecentralizedWeatherPullOracleFeed.totalReports()
    totalReports = totalReports.toString(10);
    assert.equal(totalReports, 50);
    
    var consensusResult = await _DecentralizedPullOracleFeedConsumer.getResult(currentDate);
  
    assert.equal(await _DecentralizedPullOracleFeedConsumer.resolution().then(res => res.toString(10)), 9);
  })
});

contract("DecentralizedWeatherPullOracleFeed", (accounts) => {
  let _DecentralizedWeatherPullOracleFeed;
  
  before(async () => {
    _DecentralizedWeatherPullOracleFeed = await DecentralizedWeatherPullOracleFeed.new(50);
  });

  before(testGas.createGasStatCollectorBeforeHook(contracts));
  after(testGas.createGasStatCollectorAfterHook(contracts));

  it("Should start with the right numbers of totalReports and requiredReports", async () => {
    let totalReports = await _DecentralizedWeatherPullOracleFeed.totalReports();
    totalReports = totalReports.toString(10);
    assert.equal(totalReports, 0);

    let requiredReports = await _DecentralizedWeatherPullOracleFeed.requiredReports();
    requiredReports = requiredReports.toString(10);
    assert.equal(requiredReports, 50); 
  })

  it("Expect inputData function to input data into weatherConditions, increment totalReports, and set resultsSet", async () => {
    var currentDate = new Date().getUTCDate();
    let inputData = _DecentralizedWeatherPullOracleFeed.inputData(13, {
      from: accounts[0]
    });

    assert.equal(await _DecentralizedWeatherPullOracleFeed.totalReports().then(res => res.toString(10)), 1);
    assert.equal(await _DecentralizedWeatherPullOracleFeed.resultsSet(currentDate), true);
    assert.equal(await _DecentralizedWeatherPullOracleFeed.weatherConditions(currentDate, 0).then(res => res.toString(10)), 13);
  });



});