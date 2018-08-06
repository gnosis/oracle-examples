pragma solidity ^0.4.4;
import "../Interfaces/OracleConsumer.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

// it should take one day of weather, from the owner, and push the result to the OracleConsumer
// doesn't particularly need to store the weather report
contract CentralizedWeatherPushOracle is Ownable {

  /// @param _oracleConsumer The contract to which the Oracle is going to push data.
  /// @param _degreesCelsiusToday The degrees in celcius today in San Francisco, California
  function pushWeather(OracleConsumer _oracleConsumer, int _degreesCelsiusToday) public onlyOwner {
    _oracleConsumer.receiveResult(bytes32(0), bytes32(_degreesCelsiusToday));
  }

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}