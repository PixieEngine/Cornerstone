test "String#parse", ->
  equals "true".parse(), true, "parsing 'true' should equal boolean true"
  equals "false".parse(), false, "parsing 'true' should equal boolean true"
  equals "7.2".parse(), 7.2, "numbers should be cool too"

  equals '{"val": "a string"}'.parse().val, "a string", "even parsing objects works"
  
test "String#constantize", ->  
  equals "String".constantize(), String, "look up a constant"
  equals "Math".constantize(), Math, "look up a constant"
  equals "Number".constantize(), Number, "look up a constant"

test "String#blank", ->
  equals "  ".blank(), true, "A string containing only whitespace should be blank"
  equals "a".blank(), false, "A string that contains a letter should not be blank"
  equals "  a ".blank(), false
  equals "  \n\t ".blank(), true

