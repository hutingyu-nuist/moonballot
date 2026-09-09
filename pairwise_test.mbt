///|
test "pairwise counts only strict listed preferences" {
  let a = @moonballot.Ballot::new(["A", "B"], 3).unwrap()
  let b = @moonballot.Ballot::new(["B", "C"], 2).unwrap()
  let c = @moonballot.Ballot::new(["C", "A"], 1).unwrap()
  let e = @moonballot.Election::new(["A", "B", "C"], [a, b, c]).unwrap()
  assert_eq(e.pairwise(), [[0, 4, 3], [2, 0, 5], [3, 1, 0]])
  assert_eq(e.condorcet_winner(), None)
}

///|
test "condorcet winner beats every rival" {
  let a = @moonballot.Ballot::new(["A", "B"], 5).unwrap()
  let b = @moonballot.Ballot::new(["A", "C"], 4).unwrap()
  let e = @moonballot.Election::new(["A", "B", "C"], [a, b]).unwrap()
  assert_eq(e.condorcet_winner(), Some("A"))
}
