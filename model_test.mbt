///|
test "model validates ids weights and duplicates" {
  assert_eq(
    @moonballot.Ballot::new(["A", "A"], 1).unwrap_err().code,
    "ranking.duplicate",
  )
  assert_eq(
    @moonballot.Ballot::new(["A B"], 1).unwrap_err().code,
    "candidate.id",
  )
  assert_eq(@moonballot.Ballot::new(["A"], 0).unwrap_err().code, "weight.range")
  assert_eq(
    @moonballot.Election::new([], []).unwrap_err().code,
    "candidates.limit",
  )
  assert_eq(
    @moonballot.Election::new(["A", "A"], []).unwrap_err().code,
    "candidate.duplicate",
  )
}

///|
test "model rejects unknown choices and total overflow" {
  let b = @moonballot.Ballot::new(["B"], 1).unwrap()
  assert_eq(
    @moonballot.Election::new(["A"], [b]).unwrap_err().code,
    "ranking.unknown",
  )
  let large = @moonballot.Ballot::new(["A"], 1000000).unwrap()
  assert_eq(
    @moonballot.Election::new(["A"], [large, large]).unwrap_err().code,
    "total.limit",
  )
}

///|
test "model copies caller and returned arrays" {
  let ranks = ["A"]
  let b = @moonballot.Ballot::new(ranks, 2).unwrap()
  ranks[0] = "B"
  let candidates = ["A"]
  let ballots = [b]
  let e = @moonballot.Election::new(candidates, ballots).unwrap()
  candidates[0] = "C"
  ballots.clear()
  e.candidates().clear()
  e.ballots()[0].ranking().clear()
  assert_eq(e.candidates(), ["A"])
  assert_eq(e.ballots()[0].ranking(), ["A"])
  assert_eq(e.total_weight(), 2)
}

///|
test "empty rankings and zero ballots are explicit abstention profiles" {
  let b = @moonballot.Ballot::new([], 4).unwrap()
  let e = @moonballot.Election::new(["A", "B"], [b]).unwrap()
  assert_eq(e.total_weight(), 4)
  assert_eq(@moonballot.Election::new(["A"], []).unwrap().total_weight(), 0)
}
