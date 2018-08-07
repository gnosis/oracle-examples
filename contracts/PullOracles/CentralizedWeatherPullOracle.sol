pragma solidity ^0.4.4;
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../Interfaces/PullOracle.sol";

contract CentralizedWeatherPullOracle is Ownable, PullOracle {
  int8 degreesCelsius;
  bool resultSet;

  /// @param _degreesCelsius The degrees for the day in San Francisco, California
  function inputData(int8 _degreesCelsius) external onlyOwner {
    require(resultSet == false, "The result has already been set");
    resultSet = true;
    degreesCelsius = _degreesCelsius;
  }

  /// @param id The id for the event you want the resultFor, in this centralized case, should be set to 0
  function resultFor(bytes32 id) external view returns (bytes32 result) {
    require(resultSet == true, "Please be patient, the result has not been set yet.");
    return bytes32(degreesCelsius);
  }

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}