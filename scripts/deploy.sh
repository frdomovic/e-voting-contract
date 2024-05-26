#!/bin/bash

: <<'COMMENT'
USAGE

contract $: ./deploy.sh --accountId cts-acc-test7.testnet --ownerId cts-acc-test7.testnet --relayerId cts-acc-test7.testnet \\
 --registerTime 1716802125000 --voteTime 1716802125000

> blockchain-voting@1.0.0 build
> near-sdk-js build src/contract.ts build/blockchain-voting.wasm

[transpileJsAndBuildWasm] ✔  success   Generated build/blockchain-voting.wasm contract successfully!
Deploying contract build/blockchain-voting.wasm in cts-acc1.testnet
Done deploying and initializing cts-acc1.testnet
Transaction Id DuAQv6pZaMHTksAUovk9m7ReYjDvR2qt26fQ7qkghPqs
Open the explorer for more info: https://testnet.nearblocks.io/txns/DuAQv6pZaMHTksAUovk9m7ReYjDvR2qt26fQ7qkghPqs
COMMENT

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -a|--accountId)
        ACCOUNT_ID="$2"
        shift # past argument
        shift # past value
        ;;
        -o|--ownerId)
        OWNER_ID="$2"
        shift # past argument
        shift # past value
        ;;
        -r|--relayerId)
        RELAYER_ID="$2"
        shift # past argument
        shift # past value
        ;;
        -rt|--registerTime)
        REGISTER_TIME="$2"
        shift # past argument
        shift # past value
        ;;
        -vt|--voteTime)
        VOTE_TIME="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

# Check if required arguments are provided
if [[ -z $ACCOUNT_ID ]] || [[ -z $OWNER_ID ]] || [[ -z $RELAYER_ID ]] || [[ -z $REGISTER_TIME ]] || [[ -z $VOTE_TIME ]]; then
    echo "Usage: $0 --accountId <accountId> --ownerId <ownerId> --relayerId <relayerId> --registerTime <registerTime> --voteTime <voteTime>"
    exit 1
fi

# 1. Clean up neardev directory
# 2. Build the project
# 3. Deploy the smart contract
rm -rf neardev && \
npm run build && \
near deploy $ACCOUNT_ID ../build/blockchain-voting.wasm --initFunction init --initArgs '{"_owner_id":"'$OWNER_ID'", "_relayer_id": "'$RELAYER_ID'", "_register_time": "'$REGISTER_TIME'", "_vote_time": "'$VOTE_TIME'"}'