pragma solidity ^0.4.4;
import "../Interfaces/PullOracle.sol";

contract DecentralizedPullOracleFeedConsumer {
  PullOracle public oracle;
  mapping (bytes32 => bytes32) public resolution;

  constructor(PullOracle _oracle) public {
    oracle = _oracle;
  }

  function getResult(bytes32 id) public {
    resolution[id] = oracle.resultFor(id);
  }
}