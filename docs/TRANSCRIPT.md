# Transcript verification

`IrvResult::to_text()` emits a stable, line-oriented representation of every IRV
round. It is intended for review logs and golden tests, not as a wire protocol.
`IrvResult::verify(election)` checks that every snapshot has the complete candidate
set, aligned tally labels, non-negative counts, and a total no larger than the
validated election weight.

A transcript is reproducible because candidate order, elimination tie-breaking,
and output order are all deterministic. The library does not claim that a text
transcript is cryptographically signed or suitable for legal election records.
