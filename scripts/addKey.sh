#!/bin/bash

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <contract_address> <secret_key> <account_id>"
  exit 1
fi

contract_address="$1"
secret_key="$2"
account_id="$3"

npx near call "$contract_address" addVotingKey "{\"_secret_key\":\"$secret_key\"}" --accountId "$account_id"
