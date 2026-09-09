///|
/// Parse `positive-weight: A > B` or `positive-weight:` for abstention.
pub fn parse_ballot(input : String) -> Result[Ballot, Diagnostic] {
  if input.length() > 4096 {
    return Err(problem("line.limit", "at most 4096 code units"))
  }
  let parts = input.split(":").to_array()
  if parts.length() != 2 {
    return Err(problem("ballot.syntax", "expected weight: ranking"))
  }
  let number = parts[0].trim().to_owned()
  if number.is_empty() {
    return Err(problem("weight.syntax", "missing decimal weight"))
  }
  let mut weight = 0
  for ch in number {
    if ch < '0' || ch > '9' {
      return Err(problem("weight.syntax", "decimal digits only"))
    }
    let digit = ch.to_int() - 48
    if weight > (1000000 - digit) / 10 {
      return Err(problem("weight.range", "expected 1..1000000"))
    }
    weight = weight * 10 + digit
  }
  let tail = parts[1].trim().to_owned()
  let ranking : Array[String] = []
  if !tail.is_empty() {
    for item in tail.split(">") {
      let id = item.trim().to_owned()
      if id.is_empty() {
        return Err(
          problem("ranking.empty", "missing candidate between separators"),
        )
      }
      ranking.push(id)
    }
  }
  Ballot::new(ranking, weight)
}
