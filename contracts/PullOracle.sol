pragma solidity ^0.4.4;

/// @title Pull Oracle Interface - Functions to be implemented by pull oracles

interface PullOracle {
    function getOutcome() external constant returns (bytes32 id, bytes result);
}