pragma solidity ^0.4.4;

interface OracleConsumer {
    function receiveResult(bytes32 id, bytes32 result) external;
    /*  
      receiveResult MUST revert if the msg.sender is not an oracle authorized to provide the result for that id
      receiveResult MAY revert if receiveResult has been called with the same id before. 
      receiveResult MAY revert if the id or result cannot be handled by the handler.
    */
}