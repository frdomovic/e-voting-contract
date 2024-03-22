#!/bin/bash

if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <contract_address> <account_id> <secret_key> <vote_option>"
  exit 1
fi

contract_address="$1"
account_id="$2"
secret_key="$3"
vote_option="$4"

near call "$contract_address" castVote '{"_secret_key": "'$secret_key'", "_vote_option": "'$vote_option'"}' --accountId "$account_id"