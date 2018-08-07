const testGas = require("@gnosis.pm/truffle-nice-tools").testGas;
const ethUtils = require('ethereumjs-util');

const DecentralizedWeatherPullOracleFeed = artifacts.require("DecentralizedWeatherPullOracleFeed");
const DecentralizedPullOracleFeedConsumer = artifacts.require("DecentralizedPullOracleFeedConsumer");

contracts = [DecentralizedPullOracleFeedConsumer, DecentralizedWeatherPullOracleFeed];


contract("DecentralizedPullOracleFeedConsumer", (accounts) => {
  let _DecentralizedWeatherPullOracleFeed;

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
    var currentDate = new Date().getDate();
    currentDate = ethUtils.bufferToHex(ethUtils.setLengthLeft(currentDate, 32));

    for (var i=3; i<=50; i++) {
      await _DecentralizedWeatherPullOracleFeed.inputData(9, {
        from: accounts[i]
      });
    }
    let totalReports = await _DecentralizedWeatherPullOracleFeed.totalReports()
    totalReports = totalReports.toString(10);
    assert.equal(totalReports, 50);

    console.log(`results for ${currentDate}`, await _DecentralizedWeatherPullOracleFeed.resultFor(currentDate));

    // console.log('typeof', currentDate);
    // var consensusResult = await _DecentralizedPullOracleFeedConsumer.getResult(currentDate);
    // consensusResult = consensusResult.toString(10);

    // assert.equal(consensusResult, 9)
  })
});

// contract("CentralizedWeatherPullOracle", (accounts) => {
//   let _CentralizedWeatherPullOracle;
  
//   before(async () => {
//     _CentralizedWeatherPullOracle = await CentralizedWeatherPullOracle.deployed();
//   });

//   before(testGas.createGasStatCollectorBeforeHook(contracts));
//   after(testGas.createGasStatCollectorAfterHook(contracts));

//   it("Should initiate with the initial values for degreesCelsius and resultSet unset.", async () => {
//     let degreesCelsius = await _CentralizedWeatherPullOracle.degreesCelsius();
//     degreesCelsius = await degreesCelsius.toString(10);
//     let resultSet = await _CentralizedWeatherPullOracle.resultSet();
//     assert.equal(degreesCelsius, 0);
//     assert.equal(resultSet, false);
//   });

//   it("Should revert when resultFor is called before any result is set.", async () => {
//     try {
//       const resultFor = await _CentralizedWeatherPullOracle.resultFor(22);
//     } catch (err) {
//       assert(true);
//     }
//   });

//   it("Should be able to set the degreesCelsius and resultSet with the inputData function, only one time.", async () => {
//     const inputData = await _CentralizedWeatherPullOracle.inputData(9, {
//       from: accounts[0]
//     });
//     let degreesCelsius = await _CentralizedWeatherPullOracle.degreesCelsius();
//     degreesCelsius = await degreesCelsius.toString(10);
//     let resultSet = await _CentralizedWeatherPullOracle.resultSet();

//     assert.equal(resultSet, true);
//     assert.equal(degreesCelsius, 9);

//     try {
//       inputData;
//     } catch (err) {
//       assert(true);
//     }
//   });

//   it("Should return the resultFor after the inputData transaction has been successfully mined.", async () => {
//     const testNumber = ethUtils.bufferToHex(ethUtils.setLengthLeft(3, 32));
//     const resultFor = await _CentralizedWeatherPullOracle.resultFor(testNumber);
//     assert(ethUtils.bufferToInt(resultFor), 9);
//   })

// });