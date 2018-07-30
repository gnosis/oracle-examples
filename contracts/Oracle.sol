pragma solidity ^0.4.4;

/// @title Oracle Interface - Functions to be implemented by oracles
interface Oracle {
    function isOutcomeSet() external constant returns (bool);
}
