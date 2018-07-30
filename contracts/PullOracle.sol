pragma solidity ^0.4.4;

/// @title Pull Oracle Interface - Functions to be implemented by pull oracles

interface PullOracle {
    function getOutcome() external view returns (bytes32, bytes);
}