# MoonBallot duplication gate — 2026-09-09

## Decision
Proceed with **offline ranked-ballot tabulation and reproducible elimination transcripts**. This is a scoped engineering originality check, not a guarantee of organizer acceptance or an exhaustive absence claim.

## Official assistant and search method
Read and applied the installed `$osc2026-guide` Project Research Guide. `moon search --help` and `moon search json --limit 20` both failed: no such subcommand. Used the public MoonCakes website search endpoint discovered in its actual frontend (`/api/v0/search?kw=...&limit=100`) instead; saved exact JSON responses under `evidence/`. Opened package documentation and relevant GitHub API/source pages. GitHub repository searches for `MoonBit ballot`, `MoonBit voting`, `MoonBit runoff` returned empty arrays. This is not MoonCakes publication.

## Candidate matrix
| Candidate | Domain / core data / workflow / result | Comparison and decision |
|---|---|---|
| MoonMime | MIME type tokens, parameter strings; parse/format/match -> normalized headers | REJECTED: marianoguerra/mcp already has general MediaType parsing, parameter lookup and to_wire. An unverified, noncompiling draft was mistakenly written before the gate; it is excluded from this project. |
| Sudoku solver | puzzle grids, candidate digits; exact cover/backtracking -> solutions | REJECTED: trash33/sudoku 0.1.0 and bobzhang/loop_invariants_graph exact-cover examples already cover the core. |
| WAV processing | samples, channels; decode/process/encode -> audio | REJECTED: bw448/moon-wav 0.3.0 already covers WAV codec and audio processing. |
| MoonBallot | candidate IDs, weighted strict rankings, pairwise preferences, elimination rounds; validate -> count -> replay -> compare -> transcript | SELECTED: no direct maintained ranked-ballot tabulator found in the inspected results. |

## MoonCakes query results
- `moonballot`, `ranked choice`, `instant runoff`, `apportionment`, `condorcet`, `schulze`: 0 results.
- `ballot`: 2 modules, but matched packages describe **burst balloons** and **ball trees**, not ballots.
- `election`: 11 modules, notably Raft/leases (distributed leader election) and MoonElec (electrical engineering); not ranked preference tabulation.
- `voting`: 3 modules: verified threshold multisig, MoonCollections frequency counts, CBTC dual-channel voting.
- `borda`: 21 fuzzy matches (mostly borders/UI); inspected matched summaries, none describes Borda ballot scoring.
- Search is fuzzy, can change, and may miss unpublished/private/new modules. Exact-name absence alone is not the conclusion. Raw responses retain irrelevant hits too.

## Adjacent projects inspected
| Package / owner / published version | Evidence and maintenance signal | Capability overlap / boundary |
|---|---|---|
| moonbit-community/verified 0.0.2 | https://mooncakes.io/docs/moonbit-community/verified@0.0.2 ; https://github.com/moonbit-community/verified ; pushed 2026-07-11, Apache-2.0 | Read threshold_multisig generated API: count_approvals/can_execute on fixed integer votes. No ranked ballots, transfer rounds or replay. |
| Zongzuixi114514/mooncollections 0.1.5 | https://mooncakes.io/docs/Zongzuixi114514/mooncollections@0.1.5 ; https://github.com/Zongzuixi114514/MoonCollections | Frequency counter/multiset, not election rules. Counting storage alone does not implement transfers. |
| bobzhang/loop_invariants_dp 0.14.0 | https://mooncakes.io/docs/bobzhang/loop_invariants_dp@0.14.0 ; https://github.com/moonbit-community/loop_invariants ; pushed 2026-09-08 | Ballot search is a balloon-DP fuzzy hit. No ballot workflow in matching package. |
| SupremeHuaji/MoonElec 0.1.0 | https://mooncakes.io/docs/SupremeHuaji/MoonElec@0.1.0 ; https://github.com/SupremeHuaji/MoonElec ; pushed 2025-12-26 | Electrical calculations, not election tabulation. |
| marianoguerra/mcp 0.10.0 | https://mooncakes.io/docs/marianoguerra/mcp@0.10.0 ; https://github.com/marianoguerra/mcp-mb ; read mcp/src/hypermedia/media_type.mbt | Direct overlap with rejected MIME candidate; not reused. |
| oboard/mimetype 0.2.0 | https://mooncakes.io/docs/oboard/mimetype@0.2.0 ; https://github.com/oboard/mimetype ; pushed 2026-08-21 | Extension/MIME database adjacent to rejected MIME topic. |
| longhuanlin/multipart-stream 0.1.1 | https://mooncakes.io/docs/longhuanlin/multipart-stream@0.1.1 ; https://github.com/longhuanlin/multipart-stream ; pushed 2026-08-24 | Multipart boundary parsing; read internal media_type source; no ballot relation. |

Independent library is justified rather than adding election semantics to a multisig or generic collection package: those have different input contracts, purpose and outputs. No code is copied from them.

## Complete local-registry comparison
- MoonBench: timings/baselines, not ballots. MoonContract: schema/HTTP enforcement, not preferences.
- MoonRecur: civil recurrence, not rounds. MoonShard: content chunks/manifests, not ranking profiles.
- MoonPatch/MoonChange: source diffs and repository governance, not candidate voting; no code-owner/quorum policy.
- MoonDag: workflow schedules/CPM, not tabulation; no task planning or duration analysis.
- MoonSPDX, clbbbb/moonbit-license-audit, liyun/moonseal, MoonSPDX Semantic Proof Engine: license compliance, not preferences.
- MoonRedact/MoonLogfmt Lens: logs/redaction, not ballots. MoonLedger: money/double entries, not vote weights.
- MoonQuotaKit: charging/rate limits, not ballot counts. MoonLeaseKit: fencing/leader election, not preference elections.
- MoonDispatch: message delivery/visibility leases, not ballots. MoonIndex/Lucius646/MoonSearch: document retrieval, not rank choices.
- MoonPalette/bobzhang/colors: color data, not ballots. MoonGCode: machine motions, not rounds.
- MoonEDI: X12 control envelopes, not tabulation. MoonWire: binary frames/checksums, not ranked preferences.
- Decision-record/template registry sections add no conflicting core workflow. Prior rejected directions remain reserved.

## Fingerprint and acceptance
Users: application authors implementing small community polls and educators comparing explicit tabulation rules. Input: bounded ASCII candidate IDs and aggregate weighted strict partial rankings; no voter identities. Algorithms: plurality, fixed-N Borda, pairwise/Condorcet/Copeland, single-seat IRV with explicit tie policy, independent transcript verification. Outputs: counts, co-winners, per-round active/exhausted weights, elimination decisions and deterministic text/JSON.

Acceptance: a first-choice leader loses after transfers; a Condorcet cycle returns no winner; deliberate transcript tampering fails replay; permutation and weight-splitting preserve results across MoonBit targets.

Non-goals: election infrastructure, voter registration, cryptography, legal certification, public-election suitability, multi-seat STV, tied ranks, distributed leader election, HTTP contracts and every earlier project's central workflow.

Recheck before remote publication. Status: local duplication gate complete on 2026-09-09; MoonCakes not published.
