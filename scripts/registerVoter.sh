#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <contract_address> <account_to_register>"
  exit 1
fi

contract_address="$1"
account_to_register="$2"


# Call the registerVoter method
near call "$contract_address" registerVoter --accountId "$account_to_register"
