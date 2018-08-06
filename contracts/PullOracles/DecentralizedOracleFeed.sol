pragma solidity ^0.4.4; 
import "../Interfaces/OracleConsumer.sol";

contract DecentralizedOracleFeed {
  uint128 totalReports;
  uint128 requiredReports;
  mapping (address => bool) reporters;
  mapping (uint => int8[]) degreesCelsius;

  /// @param _requiredReports The number of required reports from various accounts before the Oracle considers the data finalized
  constructor(uint128 _requiredReports) public {
    requiredReports = _requiredReports;
  }
   
  function inputData(int8 _degreesCelsius) public {
    require(totalReports < requiredReports, "All the necessary reports have already been reported.");
    require(!reporters[msg.sender], "This address has already submitted a report.");
      reporters[msg.sender] = true;
      totalReports++;
      degreesCelsius[now].push(_degreesCelsius);
  }

  /// @param _date The date for the weather report in Unix timestamp.
  function getAverageTemp(uint _date) public view returns (int) {
    int totalAddedDegrees;
    for (uint i=0; i<degreesCelsius[_date].length - 1; i++) {
      totalAddedDegrees += degreesCelsius[_date][i];
    }
    return totalAddedDegrees / int(degreesCelsius[_date].length);
  }

  /// @param _date The date for the weather report in Unix timestamp.
  /// @param _oracleConsumer The contract to which this Oracle is going to push data.
  function pushWeather(OracleConsumer _oracleConsumer, uint _date) public {
    require(totalReports >= requiredReports);
    _oracleConsumer.receiveResult(bytes32(0), bytes32(getAverageTemp(_date)));
  } 

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}