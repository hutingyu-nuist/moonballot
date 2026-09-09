///|
/// Stable diagnostics. Lines are 1-based for text input, 0 for value APIs.
pub(all) struct Diagnostic {
  code : String
  line : Int
  detail : String
} derive(Eq, Debug)

///|
/// Aggregate ballot: no voter identity or personal data.
pub struct Ballot {
  ranking : Array[String]
  weight : Int
} derive(Eq, Debug)

///|
/// A bounded, validated profile. Internal arrays never escape by reference.
pub struct Election {
  candidates : Array[String]
  ballots : Array[Ballot]
  total : Int
} derive(Eq, Debug)

///|
fn problem(code : String, detail : String) -> Diagnostic {
  { code, line: 0, detail }
}

///|
fn valid_id(id : String) -> Bool {
  if id.length() < 1 || id.length() > 48 {
    return false
  }
  for ch in id {
    if !(ch >= 'A' && ch <= 'Z') &&
      !(ch >= 'a' && ch <= 'z') &&
      !(ch >= '0' && ch <= '9') &&
      ch != '_' &&
      ch != '-' {
      return false
    }
  }
  true
}

///|
pub fn Ballot::new(
  ranking : Array[String],
  weight : Int,
) -> Result[Ballot, Diagnostic] {
  if weight < 1 || weight > 1000000 {
    return Err(problem("weight.range", "expected 1..1000000"))
  }
  if ranking.length() > 64 {
    return Err(problem("ranking.limit", "at most 64 ranks"))
  }
  for i, id in ranking {
    if !valid_id(id) {
      return Err(problem("candidate.id", id))
    }
    for j = 0; j < i; j = j + 1 {
      if ranking[j] == id {
        return Err(problem("ranking.duplicate", id))
      }
    }
  }
  Ok({ ranking: ranking.copy(), weight })
}

///|
pub fn Ballot::ranking(self : Ballot) -> Array[String] {
  self.ranking.copy()
}

///|
pub fn Ballot::weight(self : Ballot) -> Int {
  self.weight
}

///|
pub fn Election::new(
  candidates : Array[String],
  ballots : Array[Ballot],
) -> Result[Election, Diagnostic] {
  if candidates.length() < 1 || candidates.length() > 64 {
    return Err(problem("candidates.limit", "expected 1..64 candidates"))
  }
  for i, id in candidates {
    if !valid_id(id) {
      return Err(problem("candidate.id", id))
    }
    for j = 0; j < i; j = j + 1 {
      if candidates[j] == id {
        return Err(problem("candidate.duplicate", id))
      }
    }
  }
  if ballots.length() > 10000 {
    return Err(problem("ballots.limit", "at most 10000 rows"))
  }
  let mut total = 0
  for ballot in ballots {
    if total > 1000000 - ballot.weight {
      return Err(problem("total.limit", "total weight exceeds 1000000"))
    }
    total += ballot.weight
    for id in ballot.ranking {
      if !candidates.contains(id) {
        return Err(problem("ranking.unknown", id))
      }
    }
  }
  Ok({ candidates: candidates.copy(), ballots: ballots.copy(), total })
}

///|
pub fn Election::candidates(self : Election) -> Array[String] {
  self.candidates.copy()
}

///|
pub fn Election::ballots(self : Election) -> Array[Ballot] {
  self.ballots.copy()
}

///|
pub fn Election::total_weight(self : Election) -> Int {
  self.total
}
