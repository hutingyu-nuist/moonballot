///|
/// First-choice weighted counts in candidate order.
pub fn Election::plurality(self : Election) -> Array[(String, Int)] {
  let scores = Array::make(self.candidates.length(), 0)
  for ballot in self.ballots {
    if ballot.ranking.length() > 0 {
      let id = ballot.ranking[0]
      for i, candidate in self.candidates {
        if candidate == id {
          scores[i] += ballot.weight
        }
      }
    }
  }
  let out = []
  for i, candidate in self.candidates {
    out.push((candidate, scores[i]))
  }
  out
}

///|
/// Candidates tied for the maximum plurality score.
pub fn Election::plurality_winners(self : Election) -> Array[String] {
  let rows = self.plurality()
  let mut best = -1
  for row in rows {
    if row.1 > best {
      best = row.1
    }
  }
  let out = []
  for row in rows {
    if row.1 == best {
      out.push(row.0)
    }
  }
  out
}

///|
/// Fixed-N Borda score. Unranked candidates tie at zero.
pub fn Election::borda(self : Election) -> Array[(String, Int)] {
  let scores = Array::make(self.candidates.length(), 0)
  let n = self.candidates.length()
  for ballot in self.ballots {
    let ranks = ballot.ranking.length()
    for pos, id in ballot.ranking {
      for i, candidate in self.candidates {
        if candidate == id {
          scores[i] += ballot.weight * (n - pos - 1)
        }
      }
    }
    if ranks == 0 {
      ()
    }
  }
  let out = []
  for i, candidate in self.candidates {
    out.push((candidate, scores[i]))
  }
  out
}

///|
/// Candidates tied for the maximum Borda score.
pub fn Election::borda_winners(self : Election) -> Array[String] {
  let rows = self.borda()
  let mut best = -1
  for row in rows {
    if row.1 > best {
      best = row.1
    }
  }
  let out = []
  for row in rows {
    if row.1 == best {
      out.push(row.0)
    }
  }
  out
}
