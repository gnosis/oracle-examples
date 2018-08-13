pragma solidity ^0.4.4; 
import "../Interfaces/OracleConsumer.sol";

contract DecentralizedIntegerPushOracleFeed {
  mapping (address => bool) public reporters;
  int[] public integerReports;
  int[] public runningAverage;
   
  function inputData(int8 _integer) public {
    require(!reporters[msg.sender], "You have already input an integer.");
      integerReports.push(_integer);
      runningAverage.push(getAverage());
  }

  function getAverage() public view returns (int) {
    int totalSummed;
    for (uint i=0; i<integerReports.length; i++) {
      totalSummed += integerReports[i];
    }
    return totalSummed / int(integerReports.length);
  }

  /// @param _oracleConsumer The contract to which this Oracle is going to push data.
  function pushInteger(OracleConsumer _oracleConsumer, uint _id) public {
    _oracleConsumer.receiveResult(bytes32(_id), bytes32(runningAverage[_id]));
  } 

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}