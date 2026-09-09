///|
/// Read the versioned, bounded profile format documented in docs/FORMAT.md.
pub fn parse_profile(input : String) -> Result[Election, Diagnostic] {
  if input.length() > 2000000 {
    return Err(problem("input.limit", "at most 2000000 code units"))
  }
  let candidates : Array[String] = []
  let ballots : Array[Ballot] = []
  let mut stage = 0
  let mut line_no = 0
  let mut total = 0
  for raw in input.split("\n") {
    line_no += 1
    let line = raw.trim().to_owned()
    if line.is_empty() || line.has_prefix("#") {
      continue
    }
    if line.length() > 4096 {
      return Err({
        code: "line.limit",
        line: line_no,
        detail: "at most 4096 code units",
      })
    }
    if stage == 0 {
      if line != "moonballot 1" {
        return Err({
          code: "profile.version",
          line: line_no,
          detail: "expected moonballot 1",
        })
      }
      stage = 1
    } else if stage == 1 {
      if !line.has_prefix("candidates:") {
        return Err({
          code: "profile.candidates",
          line: line_no,
          detail: "expected candidates: A,B",
        })
      }
      for item in line[11:].split(",") {
        candidates.push(item.trim().to_owned())
      }
      match Election::new(candidates, []) {
        Err(e) => return Err({ ..e, line: line_no })
        Ok(_) => ()
      }
      stage = 2
    } else {
      let ballot = match parse_ballot(line) {
        Err(e) => return Err({ ..e, line: line_no })
        Ok(b) => b
      }
      for id in ballot.ranking {
        if !candidates.contains(id) {
          return Err({ code: "ranking.unknown", line: line_no, detail: id })
        }
      }
      if total > 1000000 - ballot.weight {
        return Err({
          code: "total.limit",
          line: line_no,
          detail: "total weight exceeds 1000000",
        })
      }
      total += ballot.weight
      ballots.push(ballot)
      if ballots.length() > 10000 {
        return Err({
          code: "ballots.limit",
          line: line_no,
          detail: "at most 10000 rows",
        })
      }
    }
  }
  if stage < 2 {
    return Err({
      code: "profile.incomplete",
      line: line_no,
      detail: "version and candidates required",
    })
  }
  Election::new(candidates, ballots)
}
