pragma solidity ^0.4.4;
import "../Oracle.sol";
import "../PushOracle.sol";
import "../../test/contracts/OracleConsumer.sol";

contract PonziSchemeFeed is Oracle, PushOracle {
    struct ponziDataFeedStruct {
        uint timestamp;
        uint funds;
    }
    ponziDataFeedStruct[] public datafeed;
    address public ponziContractAddress = 0xA62142888ABa8370742bE823c1782D17A0389Da1;
    
    constructor() public {
        
    }

    function logData(uint _funds) public {
        datafeed.push(ponziDataFeedStruct({
            timestamp: now,
            funds: _funds
        }));
    }

    function isOutcomeSet() public view returns (bool) {
        if (datafeed.length > 0) {
            return true;
        }
        return false;
    }

    function pushOutcome(OracleConsumer consumer) public {
        // consumer.receiveResult()
    }
}