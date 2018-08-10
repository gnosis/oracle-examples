pragma solidity ^0.4.4;
import "../../../contracts/Interfaces/OracleConsumer.sol";

contract DecentralizedPushOracleFeedConsumer is OracleConsumer {
  address oracle;
  int8 resolution;

  constructor(address _oracle) public {
    oracle = _oracle;
  }

  function receiveResult(bytes32 id, bytes32 result) external {
    if (msg.sender != oracle) {
      revert("The message sender is not an authorized oracle.");
    }
    // check id and store in bytes32 => bytes32 mapping
    resolution = int8(result);
  }
}