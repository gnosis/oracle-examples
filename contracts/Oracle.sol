pragma solidity ^0.4.4;

/// @title Pull Oracle Interface - Functions to be implemented by oracles
interface Oracle {
    function isOutcomeSet() public constant returns (bool);
    function getOutcome() public constant returns (int);
}
