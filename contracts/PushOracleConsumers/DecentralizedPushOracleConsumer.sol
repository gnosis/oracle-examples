pragma solidity ^0.4.4;
import "../Interfaces/OracleConsumer.sol";

contract DecentralizedPushOracleConsumer is OracleConsumer {
  address public oracle;
  bytes32 public resolution;

  constructor(address _oracle) public {
    oracle = _oracle;
  }

  function receiveResult(bytes32 id, bytes32 result) external {
    if (msg.sender != oracle) {
      revert("The message sender is not an authorized oracle.");
    }
    resolution = result;
  }
}