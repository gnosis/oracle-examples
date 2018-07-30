pragma solidity ^0.4.4;
import "../Oracle.sol";
import "../../test/contracts/OracleConsumer.sol";

contract PonziSchemeFeed is Oracle {
    struct ponziDataFeedStruct {
        uint timestamp;
        uint funds;
    }
    ponziDataFeedStruct[] public datafeed;
    address public ponziContractAddress = 0xA62142888ABa8370742bE823c1782D17A0389Da1;
    
    constructor() public {
        // Should the feed Oracles implement the first call in the constructor, or do they need an isOutcomeSet() function at all?
    }

    function logData() public {
        datafeed.push(ponziDataFeedStruct({
            timestamp: now,
            funds: ponziContractAddress.balance
        }));
    }

    function isOutcomeSet() public view returns (bool) {
        if (datafeed.length > 0) {
            return true;
        }
        return false;
    }

    function pushOutcome(uint id, uint result, OracleConsumer consumer) public {
        consumer.receiveResult(bytes32(id), abi.encode(result));
    }
}