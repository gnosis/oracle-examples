pragma solidity ^0.4.4;
import "./OracleConsumer.sol";

contract OracleConsumerExample is OracleConsumer {
    // set the Oracle upon construction
    bytes result;
    bytes metadata;
    bytes32 oracle;
    bool outcomeReported = false;

    constructor(bytes32 _id) {
        oracle = _id;
    }

    function receiveResult(bytes32 _id, bytes _result, bytes _metadata) external {
        require(oracle == _id, "You're not the oracle!");
        require(outcomeReported == false);

        result = _result;
        metadata = _metadata;
        outcomeReported = true;
    }
}