pragma solidity ^0.4.4;
import "../Interfaces/OracleConsumer.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract CentralizedIntegerPushOracle is Ownable {

  /// @param _oracleConsumer The contract to which the Oracle is going to push data.
  function pushInteger(OracleConsumer _oracleConsumer, int _integer) public onlyOwner {
    _oracleConsumer.receiveResult(bytes32(0), bytes32(_integer));
  }

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}