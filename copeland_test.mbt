///|
test "copeland scores strict pairwise wins" {
  let a = @moonballot.Ballot::new(["A", "B", "C"], 3).unwrap()
  let b = @moonballot.Ballot::new(["B", "C", "A"], 2).unwrap()
  let e = @moonballot.Election::new(["A", "B", "C"], [a, b]).unwrap()
  assert_eq(e.copeland(), [("A", 1), ("B", 1), ("C", -2)])
  assert_eq(e.copeland_winners(), ["A", "B"])
}
