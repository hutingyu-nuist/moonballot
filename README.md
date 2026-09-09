# MoonBallot

MoonBallot is an original, offline MoonBit library for deterministic ranked-ballot tabulation. It supports community-poll experiments, teaching materials and reproducible algorithm comparisons without collecting voter identities or providing election infrastructure.

## API

- `Ballot::new` and `Election::new` validate bounded data.
- `parse_ballot` and `parse_profile` import a small versioned text format.
- `plurality`, `borda`, `pairwise` and `condorcet_winner` compare methods.
- `irv` returns deterministic round snapshots, exhausted weight, elimination and a winner or safe tie.

```moonbit
let election = @moonballot.parse_profile("moonballot 1\ncandidates: A, B\n3: A>B\n2: B>A\n").unwrap()
let result = election.irv()
inspect(result.winner(), content="Some(\"A\")")
```

## Limits and boundaries

Inputs are bounded to 64 candidates, 10,000 ballot rows and total weight 1,000,000. The project does not implement voter registration, cryptography, legal certification, public-election operations, multi-seat STV, tied ranks, network services, distributed leader election or binary framing.

## Verification

```text
moon fmt --check
moon check --target wasm-gc --deny-warn
moon check --target wasm --deny-warn
moon check --target js --deny-warn
moon check --target native --deny-warn
moon test --target wasm-gc --deny-warn
```

## Provenance and license

This is an original MoonBit implementation. It depends only on `moonbitlang/core`; no third-party source or test corpus is copied. AI assistance was used for brainstorming, implementation and debugging; the author reviewed the result. MIT license, see `LICENSE`.

## Example

The repository includes `examples/community-poll.mb`, a small offline profile for
trying the parser and comparing IRV, Borda, plurality and pairwise projections.
