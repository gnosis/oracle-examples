pragma solidity ^0.4.4; 
import "../Interfaces/OracleConsumer.sol";
import "../Interfaces/PullOracle.sol";

contract DecentralizedWeatherPullOracle is PullOracle {

  uint128 public totalReports;
  uint128 public requiredReports;
  mapping (address => bool) public reporters;
  int8[] public degreesCelsius;

  constructor(uint128 _requiredReports) public {
    requiredReports = _requiredReports;
  } 
  
  function inputData(int8 _degreesCelsius) public {
    require(totalReports < requiredReports, "All the necessary reports have already been reported.");
    require(!reporters[msg.sender], "This address has already submitted a report.");
      reporters[msg.sender] = true;
      totalReports++;
      degreesCelsius.push(_degreesCelsius);
  }

  function getAverageTemp() public view returns (int) {
    int totalAddedDegrees;
    for (uint i=0; i<degreesCelsius.length; i++) {
      totalAddedDegrees += degreesCelsius[i];
    }
    return totalAddedDegrees / int(degreesCelsius.length);
  }

  function resultFor(bytes32 id) view public returns (bytes32 result) {
    require(totalReports >= requiredReports, "Not enough people have reported yet");
    return bytes32(getAverageTemp());
  }

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}