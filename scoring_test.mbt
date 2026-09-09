///|
test "plurality weights first ranked choice and abstention" {
  let a = @moonballot.Ballot::new(["A", "B"], 3).unwrap()
  let b = @moonballot.Ballot::new(["B", "A"], 2).unwrap()
  let c = @moonballot.Ballot::new([], 4).unwrap()
  let e = @moonballot.Election::new(["A", "B", "C"], [a, b, c]).unwrap()
  assert_eq(e.plurality(), [("A", 3), ("B", 2), ("C", 0)])
  assert_eq(e.plurality_winners(), ["A"])
}

///|
test "plurality co-winners preserve candidate order" {
  let a = @moonballot.Ballot::new(["B"], 1).unwrap()
  let b = @moonballot.Ballot::new(["A"], 1).unwrap()
  let e = @moonballot.Election::new(["A", "B"], [a, b]).unwrap()
  assert_eq(e.plurality_winners(), ["A", "B"])
}

///|
test "borda scores full and partial rankings" {
  let a = @moonballot.Ballot::new(["A", "B"], 2).unwrap()
  let b = @moonballot.Ballot::new(["C"], 1).unwrap()
  let e = @moonballot.Election::new(["A", "B", "C"], [a, b]).unwrap()
  assert_eq(e.borda(), [("A", 4), ("B", 2), ("C", 2)])
  assert_eq(e.borda_winners(), ["A"])
}
