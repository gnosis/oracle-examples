pragma solidity ^0.4.4;
import "../test/contracts/OracleConsumer.sol";

/// @title Push Oracle Interface - Functions to be implemented by oracles
interface PushOracle {
    function pushOutcome(bytes32 id, bytes result, OracleConsumer consumer) external;
}
