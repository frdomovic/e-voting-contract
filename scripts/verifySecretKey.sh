#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <contract_address>"
  exit 1
fi

contract_address="$1"

near view "$contract_address" verifyVotingKey '{"_secret_key": "sck"}'