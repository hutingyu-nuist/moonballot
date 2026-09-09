///|
/// Deterministic IRV round transcript encoding.
pub fn IrvResult::to_text(self : IrvResult) -> String {
  let out = StringBuilder()
  for index, round in self.rounds {
    out.write_string("round \{index + 1}: active=")
    out.write_string(round.active.join(","))
    out.write_string("; tallies=")
    for i, pair in round.tallies {
      if i > 0 {
        out.write_string(",")
      }
      out.write_string("\{pair.0}=\{pair.1}")
    }
    out.write_string("; exhausted=\{round.exhausted}")
    match round.eliminated {
      Some(id) => out.write_string("; eliminated=\{id}")
      None => ()
    }
    match round.winner {
      Some(id) => out.write_string("; winner=\{id}")
      None => ()
    }
    out.write_string("\n")
  }
  match self.winner {
    Some(id) => out.write_string("result: winner=\{id}\n")
    None => out.write_string("result: tie\n")
  }
  out.to_string()
}

///|
/// Verify that a result has internally consistent round snapshots.
pub fn IrvResult::verify(
  self : IrvResult,
  election : Election,
) -> Result[Unit, Diagnostic] {
  if self.rounds.length() == 0 {
    return Err({ code: "transcript.empty", line: 0, detail: "no rounds" })
  }
  for round in self.rounds {
    if round.active.length() == 0 {
      return Err({
        code: "transcript.active",
        line: 0,
        detail: "empty active set",
      })
    }
    if round.active.length() != round.tallies.length() {
      return Err({
        code: "transcript.tallies",
        line: 0,
        detail: "active/tally mismatch",
      })
    }
    let mut sum = round.exhausted
    for pair in round.tallies {
      if pair.1 < 0 {
        return Err({ code: "transcript.negative", line: 0, detail: pair.0 })
      }
      sum += pair.1
    }
    if sum > election.total_weight() {
      return Err({
        code: "transcript.weight",
        line: 0,
        detail: "round exceeds total",
      })
    }
  }
  Ok(())
}
