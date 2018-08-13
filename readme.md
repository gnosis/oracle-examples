#### NOTE: The standard is still being refined, and will most likely be using **bytes** rather than **bytes32** for the results. While the functionality for decoding **bytes** in Solidity is not ready yet unfortunately, it is coming soon.   

## Oracle-Examples
A collection of Oracles built in accordance with the upcoming EIP specification for standardizing Oracles. 
More information can be found at [EIP 1154: Oracle Interface](https://github.com/ethereum/EIPs/issues/1161)

### Contents:
Inside the contracts folder example collections are split up into **Pull Oracles**, **Push Oracles**. 
While standardized interfaces can be found in the **Interfaces** folder.
Examples of Oracle Consumers can be found in the **OracleConsumers** folder.   

#### Push Oracle Interface
`
interface OracleHandler {
    function receiveResult(bytes32 id, bytes32 result) external;
}
receiveResult MUST revert if the msg.sender is not an oracle authorized to provide the result for that id.

receiveResult MUST revert if receiveResult has been called with the same id before.

receiveResult MAY revert if the id or result cannot be handled by the handler.
`

#### Pull Oracle Interface
`
interface Oracle {
    function resultFor(bytes32 id) external view returns (bytes32 result);
}
resultFor MUST revert if the result for an id is not available yet.

resultFor MUST return the same result for an id after that result is available.
`

#### Branches
There are two active branches to this repository, `integer-oracles`, which is a very simpler implementation. 
Along with `weather-oracles` which is a little bit more complex implementation.

#### Test Cases:
For `truffle test` to work correctly, you would need to start a test chain with at least 55 sample accounts. The code to do so with ganache is `ganache-cli -d -a 55` 
