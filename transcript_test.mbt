///|
test "transcript is deterministic and verifies" {
  let a = @moonballot.Ballot::new(["A"], 3).unwrap()
  let b = @moonballot.Ballot::new(["B", "A"], 2).unwrap()
  let e = @moonballot.Election::new(["A", "B"], [a, b]).unwrap()
  let r = e.irv()
  assert_eq(r.verify(e), Ok(()))
  assert_eq(
    r.to_text(),
    "round 1: active=A,B; tallies=A=3,B=2; exhausted=0; winner=A\nresult: winner=A\n",
  )
}
