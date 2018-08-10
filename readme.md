## Oracle-Examples
A collection of Oracles built in accordance with the upcoming EIP specification for standardizing Oracles. 
More information can be found at [EIP 1154: Oracle Interface](https://github.com/ethereum/EIPs/issues/1161)

#### Contents:
Inside the contracts folder example collections are split up into **Pull Oracles**, **Push Oracles**. 
While standardized interfaces can be found in the **Interfaces** folder.
Examples of Oracle Consumers can be found in the **OracleConsumers** folder.   

#### Test Cases:
For `truffle test` to work correctly, you would need to start a test chain with at least 55 sample accounts. The code to do so with ganache is `ganache-cli -d -a 55` 
