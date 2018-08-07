pragma solidity ^0.4.4;
import "../Interfaces/OracleConsumer.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../lib/time/DateTime.sol";

contract CentralizedWeatherPushFeedOracle is Ownable, DateTime {
  // mapping holds all of the dates => temp, or should an array hold this data?
  mapping (uint => int8) weatherConditions;

  /// @param _degreesCelsius The degrees in celcius at the current time in San Francisco, California 
  function inputData(int8 _degreesCelsius) public onlyOwner {
    weatherConditions[parseTimestamp(now).day] = _degreesCelsius;
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

/* TODO
Separate DateTime into it's own library contract 
Create more than just the days [seconds, minutes, years] identifiers
*/