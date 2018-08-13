pragma solidity ^0.4.4;
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract CentralizedIntegerPullFeedOracle is Ownable {
   int[] public integerFeed;

  function inputData(int8 _integer) public onlyOwner {
    integerFeed.push(_integer);
  }

  function resultFor(bytes32 id) view public returns (bytes32 result) {
    return bytes32(integerFeed[uint(id)]);     
  }

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}