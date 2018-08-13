pragma solidity ^0.4.4; 
import "../Interfaces/PullOracle.sol";

contract DecentralizedIntegerPullOracleFeed is PullOracle {
  mapping (address => bool) public reporters;
  int[] public integerReports;
  int[] public runningAverage;

  function inputData(int8 _integer) public {
    require(!reporters[msg.sender], "You have already input an integer.");
      integerReports.push(_integer);
      runningAverage.push(getAverage());
  }

  function getAverage() public view returns (int) {
    int totalSummed;
    for (uint i=0; i<integerReports.length; i++) {
      totalSummed += integerReports[i];
    }
    return totalSummed / int(integerReports.length);
  }

  function resultFor(bytes32 id) view public returns (bytes32 result) {
    return bytes32(runningAverage[uint(id)]);
  }

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}
