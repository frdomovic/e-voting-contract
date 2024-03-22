import {
  NearBindgen,
  near,
  call,
  view,
  UnorderedMap,
  initialize,
  assert,
  TextEncoder,
  LookupSet,
} from "near-sdk-js";
import { sha256 } from "near-sdk-js/lib/api";

@NearBindgen({ requireInit: true })
export class VotingContract {
  owner_id: string = "";
  relayer_id: string = "";
  voting_keys: UnorderedMap<boolean> = new UnorderedMap<boolean>("voting-keys");
  voters: LookupSet<string> = new LookupSet<string>("voters");
  voting_options: UnorderedMap<number> = new UnorderedMap<number>(
    "vote-options"
  );
  register_time: number = 0;
  vote_time: number = 0;

  @initialize({})
  init({ _owner_id, _relayer_id, _register_time, _vote_time }) {
    this.owner_id = _owner_id;
    this.relayer_id = _relayer_id;
    this.register_time = _register_time;
    this.vote_time = _vote_time
  }

  constructor() {}

  @call({})
  addVotingKey({ _secret_key }) {
    const caller_id = near.predecessorAccountId();

    assert(
      caller_id == this.relayer_id,
      "Only relayer account can add voting Keys"
    );

    const keyExists: boolean | null = this.voting_keys.get(_secret_key);

    if (keyExists == null) {
      near.log("Secret key successfully added.");
      this.voting_keys.set(_secret_key, false);
      return true;
    } else {
      near.log("Secret key is already added.");
      return false;
    }
  }

  @view({})
  viewVotingKeys() {
    return this.voting_keys._keys.toArray();
  }

  @view({})
  viewTimeLimits() {
    return JSON.stringify({vote_time: this.vote_time, register_time: this.register_time});
  }

  @call({})
  registerVoter() {
    const caller_id = near.predecessorAccountId();
    const voterExists = this.voters.contains(caller_id);

    if (voterExists) {
      near.log("Voter already registered.");
      return false;
    } else {
      this.voters.set(caller_id);
      return true;
    }
  }

  @view({})
  viewVoters() {
    return this.voters;
  }

  @call({})
  addVotingOption({ _voting_option }) {
    const caller_id = near.predecessorAccountId();

    assert(
      caller_id == this.owner_id,
      "Only owner account can add voting options."
    );

    const optionsExists: number | null =
      this.voting_options.get(_voting_option);

    if (optionsExists == null) {
      this.voting_options.set(_voting_option, 0);
      return true;
    } else {
      near.log("Voting option already added.");
      return false;
    }
  }

  @view({})
  viewVotingOptions() {
    return this.voting_options.toArray();
  }

  @call({})
  castVote({ _secret_key, _vote_option }) {
    const caller_id = near.predecessorAccountId();

    assert(
      caller_id == this.relayer_id,
      "Voting can only be executed through a relayer account."
    );


    const encoder = new TextEncoder();
    const encodedText = encoder.encode(_secret_key);
    const hash = sha256(encodedText);
    const hexHash = hash.toString();
    
    const keyExists: boolean | null = this.voting_keys.get(hexHash);

    if (keyExists == null) {
      near.log("Secret key not valid.");
      return {result: false, error: "Secret key not valid."};
    } else {
      if (keyExists) {
        near.log("Secret key already used.");
        return {result: false, error: "Secret key already used."};
      }
    }

    const optionsExists: number | null = this.voting_options.get(_vote_option);

    if (optionsExists == null) {
      near.log("Option does not exist.");
      return false;
    } else {
      this.voting_keys.set(hexHash, true);
      let currentVote = this.voting_options.get(_vote_option) + 1;
      this.voting_options.set(_vote_option, currentVote);
      near.log("Vote succeeded.");
      return {result: true, error: "Vote succeeded."};
    }
  }
}