pragma solidity ^0.4.4; 
import "../Interfaces/OracleConsumer.sol";

contract DecentralizedIntegerPushOracle {
  uint128 public totalReports;
  uint128 public requiredReports;
  mapping (address => bool) public reporters;
  int[] public integerReports;

  /// @param _requiredReports The number of required reports from various accounts before the Oracle considers the data finalized
  constructor(uint128 _requiredReports) public {
    requiredReports = _requiredReports;
  } 
  
  function inputData(int8 _integer) public {
    require(totalReports < requiredReports, "All the necessary reports have already been reported.");
    require(!reporters[msg.sender], "This address has already submitted a report.");
      reporters[msg.sender] = true;
      totalReports++;
      integerReports.push(_integer);
  }

  function getAverage() public view returns (int) {
    int totalSummed;
    for (uint i=0; i<integerReports.length; i++) {
      totalSummed += integerReports[i];
    }
    return totalSummed / int(integerReports.length);
  }

  /// @param _oracleConsumer The contract to which this Oracle is going to push data.
  function pushInteger(OracleConsumer _oracleConsumer) public {
    require(totalReports >= requiredReports);
    _oracleConsumer.receiveResult(bytes32(0), bytes32(getAverage()));
  }

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}