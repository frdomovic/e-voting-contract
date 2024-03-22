#!/bin/bash
: <<'COMMENT'
OUTPUT
Storing credentials for account: cts-acc1.testnet (network: testnet)
Saving key to '~/.near-credentials/testnet/cts-acc1.testnet.json'
COMMENT

near create-account cts-acc3.testnet --useFaucet
