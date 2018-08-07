pragma solidity ^0.4.4;
import "../../../contracts/Interfaces/PullOracle.sol";


contract CentralizedPullOracleConsumer {
  PullOracle public oracle;
  int8 public resolution;

  constructor(PullOracle _oracle) public {
    oracle = _oracle;
  }

  function getResult(bytes32 id) public {
    bytes32 result = oracle.resultFor(id);
    resolution = int8(result);
  }
}