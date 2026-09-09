///|
/// Pairwise preference matrix: row candidate preferred over column candidate.
pub fn Election::pairwise(self : Election) -> Array[Array[Int]] {
  let matrix : Array[Array[Int]] = []
  for _ in self.candidates {
    matrix.push(Array::make(self.candidates.length(), 0))
  }
  for ballot in self.ballots {
    for i, left in self.candidates {
      let lp = position(ballot.ranking, left)
      for j, right in self.candidates {
        if i != j {
          let rp = position(ballot.ranking, right)
          if lp >= 0 && (rp < 0 || lp < rp) {
            matrix[i][j] += ballot.weight
          }
        }
      }
    }
  }
  matrix
}

///|
/// Condorcet winner, if one candidate beats every other candidate.
pub fn Election::condorcet_winner(self : Election) -> String? {
  let matrix = self.pairwise()
  for i, candidate in self.candidates {
    let mut wins = true
    for j = 0; j < self.candidates.length(); j = j + 1 {
      if i != j && matrix[i][j] <= matrix[j][i] {
        wins = false
      }
    }
    if wins {
      return Some(candidate)
    }
  }
  None
}

///|
fn position(items : Array[String], wanted : String) -> Int {
  for i, item in items {
    if item == wanted {
      return i
    }
  }
  -1
}
