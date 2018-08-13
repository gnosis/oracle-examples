pragma solidity ^0.4.4;
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract CentralizedIntegerPullOracle is Ownable {
  int8 public integer;
  bool public resultSet;

  /// @param _integer Set the integer result for this pull oracle here
  function inputData(int8 _integer) external onlyOwner {
    require(resultSet == false, "The result has already been set");
    resultSet = true;
    integer = _integer;
  }

  /// @param id The id for the event you want the resultFor, in this centralized case, should be set to 0
  function resultFor(bytes32 id) public view returns (bytes32 result) {
    require(resultSet == true, "Please be patient, the result has not been set yet.");
    return bytes32(integer);
  }

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}