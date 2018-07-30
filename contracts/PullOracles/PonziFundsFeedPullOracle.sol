pragma solidity ^0.4.4;
import "../Oracle.sol";
import "../PullOracle.sol";
import "../../test/contracts/OracleConsumer.sol";

contract PonziFundsFeedPullOracle is Oracle, PullOracle {
    struct ponziDataFeedStruct {
        uint timestamp;
        uint funds;
    }
    ponziDataFeedStruct[] public datafeed;
    address public ponziContractAddress = 0xA62142888ABa8370742bE823c1782D17A0389Da1;
    
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

    function getOutcome(uint _id, uint _result) public view returns (bytes32, bytes) {
        return(bytes32(_id), abi.encode(_result));
    }
}