pragma solidity ^0.4.4;
import "../Interfaces/PullOracle.sol";

contract CentralizedPullOracleConsumer {
  PullOracle public oracle;
  bytes32 public resolution;

  constructor(PullOracle _oracle) public {
    oracle = _oracle;
  }

  function getResult(bytes32 id) public {
    resolution = oracle.resultFor(id);
  }
}