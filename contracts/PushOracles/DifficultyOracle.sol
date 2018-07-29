pragma solidity ^0.4.4;
import "../PushOracle.sol";
import "../Oracle.sol";
/// @title Difficulty oracle contract - Oracle to retrieve the difficulty of the blockchain at given block
/// @author Anton Shtylman - <anton@gnosis.pm>
contract DifficultyOracle is Oracle, PushOracle {

    event OutcomeAssignment(uint difficulty);

    uint public blockNumber;
    uint public difficulty;

    /// @dev Contract constructor validates and sets target block number
    /// @param _blockNumber Target block number
    constructor(uint _blockNumber)
        public
    {
        // Block has to be in the future
        // How would this function know the block number before deployment?
        require(_blockNumber > block.number);
        blockNumber = _blockNumber;
    }

    /// @dev Sets difficulty result for the specified upon construction block
    function setOutcome()
        public
    {
        // Block number was reached and outcome was not set yet
        require(block.number >= blockNumber && difficulty == 0);
        difficulty = block.difficulty;
        emit OutcomeAssignment(difficulty);
    }

    /// @dev Returns if difficulty is set
    /// @return Is outcome set?
    function isOutcomeSet()
        public
        constant
        returns (bool)
    {
        // Difficulty is always bigger than 0
        return difficulty > 0;
    }

    /// @dev Pushes the outcome to a spericiic OracleConsumer
    /// @return Outcome
    function pushOutcome(OracleConsumer consumer)
        external
    {
        require(isOutcomeSet(), "The outcome has not yet been resolved");
        consumer.receiveResult(bytes32(0), abi.encode(difficulty));
    }
}
