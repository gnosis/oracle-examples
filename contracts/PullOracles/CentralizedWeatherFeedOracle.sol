pragma solidity ^0.4.4;
import "../Interfaces/OracleConsumer.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract CentralizedWeatherFeedOracle is Ownable {
  // mapping holds all of the dates => temp, or should an array hold this data?
  mapping (uint => int) weatherConditions;
  // owner inputs the data, and owner has to send the data

  /// @param _degreesCelsius The degrees in celcius at the current time in San Francisco, California 
  function inputData(int8 _degreesCelsius) public onlyOwner {
    weatherConditions[now] = _degreesCelsius;
  }

  /// @param _oracleConsumer The contract to which the Oracle is going to push data.
  /// @param _timestamp the timestamp of the weather data you would like to retrieve.
  function pushWeather(OracleConsumer _oracleConsumer, uint _timestamp) public onlyOwner {
    _oracleConsumer.receiveResult(bytes32(_timestamp), bytes32(weatherConditions[_timestamp]));
  }

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}