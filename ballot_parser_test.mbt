///|
test "ballot text normal whitespace abstention" {
  let b = @moonballot.parse_ballot(" 12 : A > B_2 > C-3 ").unwrap()
  assert_eq(b.ranking(), ["A", "B_2", "C-3"])
  assert_eq(b.weight(), 12)
  assert_eq(@moonballot.parse_ballot("1:").unwrap().ranking(), [])
}

///|
test "ballot syntax prevents negative decimal and overflow" {
  for input in ["-1:A", "+1:A", "1.5:A", "NaN:A", ":A"] {
    assert_eq(
      @moonballot.parse_ballot(input).unwrap_err().code,
      "weight.syntax",
    )
  }
  for input in ["0:A", "1000001:A", "9999999999999999999999999:A"] {
    assert_eq(@moonballot.parse_ballot(input).unwrap_err().code, "weight.range")
  }
}

///|
test "ballot malformed separators rejected" {
  assert_eq(@moonballot.parse_ballot("1 A").unwrap_err().code, "ballot.syntax")
  assert_eq(
    @moonballot.parse_ballot("1:A:B").unwrap_err().code,
    "ballot.syntax",
  )
  for input in ["1:A>", "1:>A", "1:A>>B"] {
    assert_eq(
      @moonballot.parse_ballot(input).unwrap_err().code,
      "ranking.empty",
    )
  }
  assert_eq(@moonballot.parse_ballot("1:A=A").unwrap_err().code, "candidate.id")
}
