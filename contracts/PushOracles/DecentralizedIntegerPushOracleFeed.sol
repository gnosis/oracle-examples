pragma solidity ^0.4.4; 
import "../Interfaces/OracleConsumer.sol";
import "../lib/time/DateTime.sol";

contract DecentralizedIntegerPushOracleFeed is DateTime {
  uint128 public totalReports;
  uint128 public requiredReports;
  mapping (address => bool) public reporters;
  mapping (uint => int8[]) public integer;

  /// @param _requiredReports The number of required reports from various accounts before the Oracle considers the data finalized
  constructor(uint128 _requiredReports) public {
    requiredReports = _requiredReports;
  }
   
  function inputData(int8 _integer) public {
    require(totalReports < requiredReports, "All the necessary reports have already been reported.");
    require(!reporters[msg.sender], "This address has already submitted a report.");
      reporters[msg.sender] = true;
      totalReports++;
      integer[parseTimestamp(now).day].push(_integer);
  }

  /// @param _date The date for the Integer report in Unix timestamp.
  function getAverageTemp(uint _date) public view returns (int) {
    int totalAddedDegrees;
    for (uint i=0; i<integer[_date].length; i++) {
      totalAddedDegrees += integer[_date][i];
    }
    return totalAddedDegrees / int(integer[_date].length);
  }

  /// @param _date The date for the Integer report in Unix timestamp.
  /// @param _oracleConsumer The contract to which this Oracle is going to push data.
  function pushInteger(OracleConsumer _oracleConsumer, uint _date) public {
    require(totalReports >= requiredReports);
    _oracleConsumer.receiveResult(bytes32(_date), bytes32(getAverageTemp(_date)));
  } 

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}