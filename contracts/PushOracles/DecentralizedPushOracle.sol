pragma solidity ^0.4.4; 
import "../Interfaces/OracleConsumer.sol";
// import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract DecentralizedPushOracle {
  // constructed with a valid number of participants; (defined in the constructor)
  uint128 totalReports;
  uint128 requiredReports;
  mapping (address => bool) reporters;
  int8[] degreesCelsius;

  /// @param _requiredReports The number of required reports from various accounts before the Oracle considers the data finalized
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
    for (uint i=0; i<degreesCelsius.length - 1; i++) {
      totalAddedDegrees += degreesCelsius[i];
    }
    return totalAddedDegrees / int(degreesCelsius.length);
  }

  function pushWeather(OracleConsumer _oracleConsumer) public {
    require(totalReports >= requiredReports);
    _oracleConsumer.receiveResult(bytes32(0), bytes32(getAverageTemp()));
  }

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}