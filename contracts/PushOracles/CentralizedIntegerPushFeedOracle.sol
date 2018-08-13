pragma solidity ^0.4.4;
import "../Interfaces/OracleConsumer.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract CentralizedIntegerPushFeedOracle is Ownable {
  int[] integerFeed;

  function inputData(int8 _integer) public onlyOwner {
    integerFeed.push(_integer);
  }

  /// @param _oracleConsumer The contract to which the Oracle is going to push data.
  function pushInteger(OracleConsumer _oracleConsumer, uint _id) public onlyOwner {
    _oracleConsumer.receiveResult(bytes32(_id), bytes32(integerFeed[_id]));
  }

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}