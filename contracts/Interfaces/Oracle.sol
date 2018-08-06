pragma solidity ^0.4.4;

interface Oracle {
    function resultFor(bytes32 id) external view returns (bytes32 result);
    /*
      resultFor MUST revert if the result for an id is not available yet.
      resultFor MUST return the same result for an id after that result is available.
    */
}