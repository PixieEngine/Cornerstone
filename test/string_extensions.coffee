test "String#parse", ->
  equals "true".parse(), true, "parsing 'true' should equal boolean true"
  equals "false".parse(), false, "parsing 'true' should equal boolean true"
  equals "7.2".parse(), 7.2, "numbers should be cool too"

  equals '{"val": "a string"}'.parse().val, "a string", "even parsing objects works"
  
  
