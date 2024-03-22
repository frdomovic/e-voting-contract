### NEAR Protocol TypeScript Smart Contract

This repository contains a TypeScript smart contract designed to run on the NEAR Protocol blockchain. The smart contract is implemented in TypeScript using the NEAR SDK.

### Getting Started

#### 1. Clone the Repository

```bash
$: git clone https://https://github.com/frdomovic/e-voting-contract
```

#### 2. Install dependencies

```bash
$: npm install
```

#### 3. Build the smart contract

```bash
$: npm run build

> blockchain-voting@1.0.0 build
> near-sdk-js build src/contract.ts build/blockchain-voting.wasm

[transpileJsAndBuildWasm] › ✔  success   Generated build/blockchain-voting.wasm contract successfully!
```

#### 4. Create the smart contract deployment account

Change accountId on line 8

```bash
$: ./scripts/createContractAccount.sh

> Storing credentials for account: contract-account.testnet (network: testnet)
> Saving key to '~/.near-credentials/testnet/contract-account.testnet.json'
```

#### 4.1. Create the smart contract relayer account

Change accountId on line 8

```bash
$: ./scripts/createContractAccount.sh

> Storing credentials for account: contract-account.testnet (network: testnet)
> Saving key to '~/.near-credentials/testnet/relayer-account.testnet.json'
```

#### 5. Deploy the smart contract to NEAR protocol testnet

```bash
$: ./scripts/deploy.sh --accountId contract-account.testnet --ownerId owner-account.testnet --relayerId relayer-account.testnet --registerTime 1711126476000 --voteTime 1711126476000

> [transpileJsAndBuildWasm] › ✔  success   Generated build/blockchain-voting.wasm contract successfully!
> Deploying contract build/blockchain-voting.wasm in contract-account.testnet
> Done deploying and initializing contract-account.testnet
> Transaction Id 4wtbLLRpG8UR9Upa4azJz7v178f8wNiD5x4pNSHE1PP
> Open the explorer for more info: https://testnet.nearblocks.io/txns/4wtbLLRpG8UR9Upa4azJz7v178f8wNiD5x4pNSHE1PP
```

#### 6. Add a voting options

Change voting options and accountId to contract account line 12 and line 13

```bash
$: ./scripts/addVotingOption.sh contract-account.testnet

> Scheduling a call: contract-account.testnet.addVotingOption({"_voting_option": "Apple"})
> Transaction Id 9ABBwDCFJrEM58NTguU9S3WD6MWVawG7siaAvSXZ8yW3
> Open the explorer for more info: https://testnet.nearblocks.io/txns/9ABBwDCFJrEM58NTguU9S3WD6MWVawG7siaAvSXZ8yW3
> true

> Scheduling a call: contract-account.testnet.addVotingOption({"_voting_option": "Orange"})
> Transaction Id FKUwsURmkBnNm4JWDrK5pYANrMcVd8vc2Hg2tikvYH36
> Open the explorer for more info: https://testnet.nearblocks.io/txns/FKUwsURmkBnNm4JWDrK5pYANrMcVd8vc2Hg2tikvYH36
> true

> View call: contract-account.testnet.viewVotingOptions()
> [ [ 'Apple', 0 ], [ 'Orange', 0 ] ]
```

#### 7. Register voter

```bash
$: ./scripts/registerVoter.sh contract-account.testnet account-to-register.testnet

> Scheduling a call: contract-account.testnet.registerVoter()
> Transaction Id 2UQSqHRFbyhwZAWN967sdepfhdzKXvoGbGxYx7uqLdKE
> Open the explorer for more info: https://testnet.nearblocks.io/txns/2UQSqHRFbyhwZAWN967sdepfhdzKXvoGbGxYx7uqLdKE
> true
```

#### 8. Add secret key (public key)

Caller accountId is relayer accountId
\_secret_key is sha256 buffer
Change line 16 in secretKeyGenerator.mjs to generate sha256 buffer

```bash
$: node secretKeyGenerator.mjs
> 178,56,19,218,127,6,107,226,83,227,189,250,65,248,126,1,11,88,95,249,112,255,84,228,40,253,204,52,176,173,30,80
```

```bash
$: ./scripts/addKey.sh contract-account.testnet secretKey relayer-accont.testnet

> Scheduling a call: contract-account.testnet.addVotingKey({"_secret_key":"178,56,19,218,127,6,107,226,83,227,189,250,65,248,126,1,11,88,95,249,112,255,84,228,40,253,204,52,176,173,30,80"})
> Doing account.functionCall()
> Receipt: BipxDCpgZYHV5ipYqW12MgMDXkR8Dxcdd4CttTosD1Wv
        Log [contract-account.testnet]: Secret key successfully added.
> Transaction Id 6JhLreDt4qrYhPnHDVrgTjDws99B2keuTr8LR9jg9eFd
> To see the transaction in the transaction explorer, please open this url in your browser
> https://explorer.testnet.near.org/transactions/6JhLreDt4qrYhPnHDVrgTjDws99B2keuTr8LR9jg9eFd
> true
```

#### 9. Cast vote

```bash
$: ./scripts/castVote.sh contract-account.testnet relayer-account.testnet abc Apple

> Scheduling a call: contract-account.testnet.castVote({"_secret_key": "secretKey", "_vote_option": "Apple"})
> Receipt: 25KG5fTDqjDGtVe47cbgo3DhRycrNyPfJpZq1Do7dDmE
        Log [contract-account.testnet]: Vote succeeded.
> Transaction Id HNygvZ1bLqAxKVJAMseQUxm7DwCDhChxZdh5uKcM6UwL
> Open the explorer for more info: https://testnet.nearblocks.io/txns/HNygvZ1bLqAxKVJAMseQUxm7DwCDhChxZdh5uKcM6UwL
> "{ result: true, error: 'Vote succeeded.' }"
```

#### 10. View voting options

```bash
$: ./scripts/viewVotingOption.sh contract-account.tesntet

> View call: contract-account.testnet.viewVotingOptions()
> [ [ 'Apple', 1 ], [ 'Orange', 0 ] ]
```

#### 11. To run the whole project - continue on readme.md for frontend and relayer repositories
