pragma solidity ^0.4.4;
import "../../../contracts/Interfaces/OracleConsumer.sol";

contract DecentralizedPullOracleFeedConsumer is OracleConsumer {
  address public oracle;
  int8 public resolution;

  constructor(address _oracle) public {
    oracle = _oracle;
  }

  function receiveResult(bytes32 id, bytes32 result) {
    if (msg.sender != oracle) {
      revert("The message sender is not an authorized oracle.");
    }

    resolution = int8(result);
  }
}