pragma solidity ^0.4.4;
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract CentralizedIntegerPullFeedOracle is Ownable {
  mapping(uint => bool) public integerFeed;

  function inputData(int8 _integer) public onlyOwner {
    require(!integerFeed[_integer], "This integer has already been set.");
    integerFeed[_integer] = true;
  }

  function resultFor(bytes32 id) view public returns (bytes32 result) {
    require(integerFeed[uint(id)], "The Integer for that date has not been set yet!");
    return bytes32(integerFeed[uint(id)]);     
  }

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}