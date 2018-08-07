pragma solidity ^0.4.4;
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../lib/time/DateTime.sol";

// @title CentralizedWeatherPullFeedOracle - Owner logs and returns the weather in degrees for various days in the month.
contract CentralizedWeatherPullFeedOracle is Ownable, DateTime {
  
  event LogWeather(uint indexed timestamp, uint8 indexed day, int8 indexed degreesCelsius);

  mapping(uint16 => int8) public weatherConditions;
  mapping(uint16 => bool) public resultsSet;

  /// @param _degreesCelsius The degrees in celcius at the current time in the chosen locale
  function inputData(int8 _degreesCelsius) public onlyOwner {
    require(!resultsSet[parseTimestamp(now).day], "The weather for that date has already been set");
    resultsSet[parseTimestamp(now).day] = true;
    weatherConditions[parseTimestamp(now).day] = _degreesCelsius;
    emit LogWeather(now, parseTimestamp(now).day, _degreesCelsius);
  }

  function resultFor(bytes32 id) view public returns (bytes32 result) {
    require(resultsSet[parseTimestamp(uint(id)).day], "The weather for that date has not been set yet!");
    return bytes32(weatherConditions[uint16(id)]);     
  }

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}

/* TODO
Separate DateTime into it's own library contract 
Create more than just the days [seconds, minutes, years] identifiers
*/