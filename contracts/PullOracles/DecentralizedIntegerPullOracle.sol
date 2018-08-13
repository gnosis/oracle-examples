pragma solidity ^0.4.4; 
import "../Interfaces/PullOracle.sol";

contract DecentralizedIntegerPullOracle is PullOracle {

  uint128 public totalReports;
  uint128 public requiredReports;
  mapping (address => bool) public reporters;
  int[] public integerReports;

  constructor(uint128 _requiredReports) public {
    requiredReports = _requiredReports;
  } 
  
  function inputData(int8 _integer) public {
    require(totalReports < requiredReports, "All the necessary reports have already been reported.");
    require(!reporters[msg.sender], "This address has already submitted a report.");
      reporters[msg.sender] = true;
      totalReports++;
      integerReports.push(_integer);
  }

  function getAverage() public view returns (int) {
    int totalSummed;
    for (uint i=0; i<integerReports.length; i++) {
      totalSummed += integerReports[i];
    }
    return totalSummed / int(integerReports.length);
  }

  function resultFor(bytes32 id) view public returns (bytes32 result) {
    require(totalReports >= requiredReports, "Not enough people have reported yet");
    return bytes32(getAverage());
  }

  function() public {
    revert("Please don't send Ether to this contract.");
  }
}