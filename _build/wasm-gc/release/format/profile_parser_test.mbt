///|
test "profile parses comments CRLF and blank lines" {
  let e = @moonballot.parse_profile(
    "#demo\r\nmoonballot 1\r\ncandidates: A, B\r\n\r\n2: A>B\r\n1:\r\n",
  ).unwrap()
  assert_eq(e.candidates(), ["A", "B"])
  assert_eq(e.total_weight(), 3)
  assert_eq(e.ballots().length(), 2)
}

///|
test "profile diagnostics preserve actual source line" {
  let e = @moonballot.parse_profile(
    "moonballot 1\ncandidates: A,B\n# comment\n1:C",
  ).unwrap_err()
  assert_eq(e.code, "ranking.unknown")
  assert_eq(e.line, 4)
  assert_eq(
    @moonballot.parse_profile("moonballot 2").unwrap_err().code,
    "profile.version",
  )
  assert_eq(
    @moonballot.parse_profile("moonballot 1\n1:A").unwrap_err().code,
    "profile.candidates",
  )
  assert_eq(
    @moonballot.parse_profile("moonballot 1").unwrap_err().code,
    "profile.incomplete",
  )
}

///|
test "profile rejects duplicated metadata and cross-row overflow" {
  assert_eq(
    @moonballot.parse_profile("moonballot 1\ncandidates: A,A").unwrap_err().code,
    "candidate.duplicate",
  )
  assert_eq(
    @moonballot.parse_profile("moonballot 1\ncandidates: A\n1000000:A\n1:A").unwrap_err().line,
    4,
  )
  assert_eq(
    @moonballot.parse_profile("moonballot 1\ncandidates: A\ncandidates: B").unwrap_err().code,
    "weight.syntax",
  )
}
