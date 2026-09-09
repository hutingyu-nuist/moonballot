///|
test "profile export round trips canonically" {
  let source = "moonballot 1\ncandidates: B, A\n2: A > B\n1: B\n"
  let election = @moonballot.parse_profile(source).unwrap()
  let canonical = election.to_profile()
  assert_eq(canonical, "moonballot 1\ncandidates: B, A\n2: A > B\n1: B\n")
  assert_eq(@moonballot.parse_profile(canonical).unwrap(), election)
}
