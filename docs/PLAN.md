# Development milestones

Each item is an independently testable deliverable, not a quota of empty commits.

1. Originality gate and isolated repository scaffolding.
2. Validated immutable election model, weights and bounded IDs.
3. Strict weighted-ranking line parser with diagnostics.
4. Versioned full-profile import, comments and line numbers.
5. Plurality scores and deterministic co-winner sets.
6. Fixed-N Borda with explicit partial-ranking semantics.
7. Pairwise matrix with tied-unranked semantics.
8. Condorcet classification including cycles.
9. Copeland win/draw/loss scoring.
10. Single-seat IRV transfer engine and exhaustion traces.
11. Explicit tie-order handling, tie stopping and terminal rules.
12. Independent transcript audit and tamper rejection.
13. Canonical profile export, round-trip and stable aggregation.
14. Candidate-withdrawal transformation with conservation.
15. Cross-method comparison and stable text report.
16. Structured JSON export and escaping.
17. Deterministic metamorphic/property test corpus.
18. Native/JS CLI adapter, real file inputs and negative flows.
19. Runnable examples and fixtures including edge cases.
20. Reproducible multi-target CI and verification scripts.
21. API/support/security/provenance/contributor documentation.
22. Final local-readiness audit, release notes and submission draft.

Design: at most 64 candidates, 10,000 distinct ballot rows and total weight 1,000,000. All score products fit signed 32-bit Int: Borda <= 63,000,000. Ballot rankings are strict partial orders: listed candidates beat all unranked; unranked candidates tie. Empty ranking is an abstention. No public-election certification, voter identities, cryptography or multi-seat STV.
