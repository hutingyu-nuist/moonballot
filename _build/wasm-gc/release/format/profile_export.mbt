///|
/// Export an election profile in the canonical versioned text format.
pub fn Election::to_profile(self : Election) -> String {
  let out = StringBuilder()
  out.write_string("moonballot 1\n")
  out.write_string("candidates: ")
  for i, candidate in self.candidates {
    if i > 0 {
      out.write_string(", ")
    }
    out.write_string(candidate)
  }
  out.write_string("\n")
  for ballot in self.ballots {
    out.write_string("\{ballot.weight}: ")
    for i, id in ballot.ranking {
      if i > 0 {
        out.write_string(" > ")
      }
      out.write_string(id)
    }
    out.write_string("\n")
  }
  out.to_string()
}
