///|
/// One deterministic single-seat instant-runoff round.
pub struct Round {
  active : Array[String]
  tallies : Array[(String, Int)]
  exhausted : Int
  eliminated : String?
  winner : String?
}

///|
/// IRV result with all completed rounds, in order.
pub struct IrvResult {
  rounds : Array[Round]
  winner : String?
}

///|
/// Run IRV; ties stop safely rather than inventing a winner.
pub fn Election::irv(self : Election) -> IrvResult {
  let active = self.candidates.copy()
  let rounds : Array[Round] = []
  let mut winner : String? = None
  let mut done = false
  while !done && active.length() > 0 {
    let tallies = Array::make(active.length(), 0)
    let mut exhausted = 0
    for ballot in self.ballots {
      match first_active(ballot.ranking, active) {
        Some(id) =>
          for i, candidate in active {
            if candidate == id {
              tallies[i] += ballot.weight
            }
          }
        None => exhausted += ballot.weight
      }
    }
    let mut top = 0
    let mut top_count = 0
    let mut top_ties = 0
    for i, score in tallies {
      if score > top_count {
        top_count = score
        top = i
        top_ties = 1
      } else if score == top_count {
        top_ties += 1
      }
    }
    let majority = self.total / 2 + 1
    if top_count >= majority || active.length() == 1 {
      winner = Some(active[top])
      rounds.push({
        active: active.copy(),
        tallies: pairs(active, tallies),
        exhausted,
        eliminated: None,
        winner,
      })
      done = true
    } else if top_ties > 1 {
      rounds.push({
        active: active.copy(),
        tallies: pairs(active, tallies),
        exhausted,
        eliminated: None,
        winner: None,
      })
      done = true
    } else {
      let before = active.copy()
      let before_tallies = pairs(before, tallies)
      let mut low = 0
      for i, score in tallies {
        if score < tallies[low] ||
          (score == tallies[low] && active[i] > active[low]) {
          low = i
        }
      }
      let removed = active.remove(low)
      rounds.push({
        active: before,
        tallies: before_tallies,
        exhausted,
        eliminated: Some(removed),
        winner: None,
      })
    }
  }
  { rounds, winner }
}

///|
fn first_active(ranking : Array[String], active : Array[String]) -> String? {
  for id in ranking {
    if active.contains(id) {
      return Some(id)
    }
  }
  None
}

///|
fn pairs(names : Array[String], scores : Array[Int]) -> Array[(String, Int)] {
  let out = []
  for i, name in names {
    out.push((name, scores[i]))
  }
  out
}

///|
/// Winner of an IRV result, if a strict majority or sole candidate was established.
pub fn IrvResult::winner(self : IrvResult) -> String? {
  self.winner
}

///|
/// Completed round snapshots.
pub fn IrvResult::rounds(self : IrvResult) -> Array[Round] {
  self.rounds.copy()
}
