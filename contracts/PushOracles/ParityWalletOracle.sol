pragma solidity ^0.4.4;
import "../Oracle.sol";
import "../PushOracle.sol";
import "../../test/contracts/OracleConsumer.sol";


contract ParityWalletOracle is Oracle {

    event ActivityFound(bool);
    // upon construction, log a certain set of balances, upon check test if they have changed
    bool activityFound;
    address[5] parityAccounts = [0x1C0e9B714Da970E6466Ba8E6980C55E7636835a6, 0x227b7656129BC07EEf947D3C019a7A8f36A24E74, 0xA8871D303c501c39deb2abe118691eEeEa813e30, 0xc7CD9d874F93F2409F39A95987b3E3C738313925, 0x3BfC20f0B9aFcAcE800D73D2191166FF16540258];
    mapping(address => uint) public parityBalances;

    constructor() public {
        for (uint i=0; i<parityAccounts.length; i++) {
            parityBalances[parityAccounts[i]] = parityAccounts[i].balance; 
        }
    }

    function isOutcomeSet() public view returns (bool) {
        return true; 
    }

    function getOutcome() public {
        for (uint i=0; i<parityAccounts.length; i++) {
            if (parityAccounts[i].balance <= parityBalances[parityAccounts[i]]) {
                activityFound = true;
            } 
        } 
        emit ActivityFound(true);
        // Should this function allow the user to automatically push the results to a consumer if the outcome is set?
    }

    function pushOutcome(OracleConsumer consumer) public {
        consumer.receiveResult(bytes32(0), abi.encode(activityFound));
    }    
}