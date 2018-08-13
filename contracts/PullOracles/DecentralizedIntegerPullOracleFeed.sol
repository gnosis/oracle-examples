pragma solidity ^0.4.4; 
import "../Interfaces/PullOracle.sol";

/// @title The DecentralizedIntegerPullOracleFeed shows how to place 2 values into the `bytes32 id` field
contract DecentralizedIntegerPullOracleFeed is PullOracle {
  uint128 public totalReports;
  uint128 public requiredReports;
  mapping (address => int[]) public integerFeed;

  /// @param _requiredReports The number of required reports from various accounts before the Oracle considers the data finalized
  constructor(uint128 _requiredReports) public {
    requiredReports = _requiredReports;
  }
   
  function inputData(int8 _integer) public {
    require(totalReports < requiredReports, "All the necessary reports have already been reported.");
    require(integerFeed[msg.sender].length <= 5, "You have already input too many integers.");
      totalReports++;
      integerFeed[msg.sender].push(_integer);
  }

  function getAverage(address _reporter) public view returns (int) {
    int totalSummed;
    for (uint i=0; i<integerFeed[_reporter].length; i++) {
      totalSummed += integerFeed[_reporter][i];
    }
    return totalSummed / int(integer.length);
  }

  function resultFor(bytes32 id) view public returns (bytes32 result) {
    require(totalReports >= requiredReports, "All the necessary reports have not been reported.");
    // It's necessary to split the id into two identifiers in this case, one for the `address` and the other for the `array index` for that user. 
    uint idField = uint(id);

    return bytes32(finalResults);
  }

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}
