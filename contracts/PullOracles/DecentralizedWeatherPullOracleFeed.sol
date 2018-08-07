pragma solidity ^0.4.4; 
import "../Interfaces/PullOracle.sol";
import "../lib/time/DateTime.sol";

contract DecentralizedWeatherPullOracleFeed is PullOracle, DateTime {
  uint128 public totalReports;
  uint128 public requiredReports;
  mapping (address => bool) public reporters;
  mapping (uint16 => int8[]) public weatherConditions;
  mapping (uint16 => bool) public resultsSet;

  /// @param _requiredReports The number of required reports from various accounts before the Oracle considers the data finalized
  constructor(uint128 _requiredReports) public {
    requiredReports = _requiredReports;
  }
   
  function inputData(int8 _degreesCelsius) public {
    require(totalReports < requiredReports, "All the necessary reports have already been reported.");
    require(!reporters[msg.sender], "This address has already submitted a report.");
      reporters[msg.sender] = true;
      totalReports++;
      weatherConditions[parseTimestamp(now).day].push(_degreesCelsius);
      resultsSet[parseTimestamp(now).day] = true;
  }

  /// @param _date The date for the weather report in Unix timestamp.
  function getAverageTemp(uint16 _date) public view returns (int) {
    require(totalReports >= requiredReports, "Not enough reporters have reported");
    int totalAddedDegrees;
    for (uint i=0; i<weatherConditions[_date].length - 1; i++) {
      totalAddedDegrees += weatherConditions[_date][i];
    }
    return totalAddedDegrees / int(weatherConditions[_date].length);
  }

  function resultFor(bytes32 id) view public returns (bytes32 result) {
    require(totalReports >= requiredReports, "All the necessary reports have not been reported.");
    // require(resultsSet[parseTimestamp(uint(id)).day], "The weather for that date has not been set yet!");
    int finalResults = getAverageTemp(uint16(id));
    return bytes32(finalResults);
    
  }

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}

/* TODO
Separate DateTime into it's own library contract 
Create more than just the days [seconds, minutes, years] identifiers
*/