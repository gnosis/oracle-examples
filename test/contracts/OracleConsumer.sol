pragma solidity ^0.4.4;

interface OracleConsumer {
    function receiveResult(bytes32 id, bytes result) external;
}