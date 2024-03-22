#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <contract_address> "
  exit 1
fi

contract_address="$1"


# Call the addVotingOption method
near call "$contract_address" addVotingOption '{"_voting_option": "Apple"}' --accountId cts-acc3.testnet
near call "$contract_address" addVotingOption '{"_voting_option": "Orange"}' --accountId cts-acc3.testnet
# View the viewVotingOptions method
near view "$contract_address" viewVotingOptions
