///|
/// Copeland score: wins minus losses in strict pairwise contests.
pub fn Election::copeland(self : Election) -> Array[(String, Int)] {
  let matrix = self.pairwise()
  let scores = Array::make(self.candidates.length(), 0)
  for i = 0; i < self.candidates.length(); i = i + 1 {
    for j = 0; j < self.candidates.length(); j = j + 1 {
      if i != j {
        if matrix[i][j] > matrix[j][i] {
          scores[i] += 1
        } else if matrix[i][j] < matrix[j][i] {
          scores[i] -= 1
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
/// Candidates tied for the highest Copeland score, in input order.
pub fn Election::copeland_winners(self : Election) -> Array[String] {
  let scores = self.copeland()
  let mut best = 0
  for pair in scores {
    if pair.1 > best {
      best = pair.1
    }
  }
  let out = []
  for pair in scores {
    if pair.1 == best {
      out.push(pair.0)
    }
  }
  out
}
