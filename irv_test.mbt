///|
test "irv transfers ballots and elects majority" {
  let a = @moonballot.Ballot::new(["A"], 3).unwrap()
  let b = @moonballot.Ballot::new(["B", "A"], 2).unwrap()
  let c = @moonballot.Ballot::new(["C", "B", "A"], 2).unwrap()
  let e = @moonballot.Election::new(["A", "B", "C"], [a, b, c]).unwrap()
  let result = e.irv()
  assert_eq(result.winner(), Some("B"))
  assert_eq(result.rounds().length(), 2)
  assert_eq(result.rounds()[0].eliminated, Some("C"))
}

///|
test "irv exhausts ballots and stops on final tie" {
  let a = @moonballot.Ballot::new(["A"], 1).unwrap()
  let b = @moonballot.Ballot::new(["B"], 1).unwrap()
  let e = @moonballot.Election::new(["A", "B"], [a, b]).unwrap()
  let result = e.irv()
  assert_eq(result.winner(), None)
  assert_eq(result.rounds().length(), 1)
}

///|
test "elimination round preserves pre-elimination snapshot" {
  let a = @moonballot.Ballot::new(["A"], 2).unwrap()
  let b = @moonballot.Ballot::new(["B"], 2).unwrap()
  let c = @moonballot.Ballot::new(["C", "A"], 1).unwrap()
  let e = @moonballot.Election::new(["A", "B", "C"], [a, b, c]).unwrap()
  let round = e.irv().rounds()[0]
  assert_eq(round.active, ["A", "B", "C"])
  assert_eq(round.tallies, [("A", 2), ("B", 2), ("C", 1)])
  assert_eq(round.eliminated, Some("C"))
}
