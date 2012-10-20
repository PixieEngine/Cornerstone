module "String"

test "#blank", ->
  equals "  ".blank(), true, "A string containing only whitespace should be blank"
  equals "a".blank(), false, "A string that contains a letter should not be blank"
  equals "  a ".blank(), false
  equals "  \n\t ".blank(), true

test "#camelize", ->
  equals "active_record".camelize(), "activeRecord"

test "#constantize", ->  
  equals "String".constantize(), String, "look up a constant"
  equals "Math".constantize(), Math, "look up a constant"
  equals "Number".constantize(), Number, "look up a constant"
  equals "Math.TAU".constantize(), Math.TAU, "namespaced constants work too"
  
test "#extension", ->
  equals "README".extension(), ""
  equals "README.md".extension(), "md"
  equals "jquery.min.js".extension(), "js"
  equals "src/bouse.js.coffee".extension(), "coffee"

test "#humanize", ->
  equals "employee_salary".humanize(), "Employee salary"

test "isString", ->
  equals "".isString?(), true, "Strings are strings"
  equals {}.isString?(), undefined, "objects are not strings"
  equals [].isString?(), undefined, "arrays are not strings"

test "#parse", ->
  equals "true".parse(), true, "parsing 'true' should equal boolean true"
  equals "false".parse(), false, "parsing 'true' should equal boolean true"
  equals "7.2".parse(), 7.2, "numbers should be cool too"

  equals '{"val": "a string"}'.parse().val, "a string", "even parsing objects works"

  ok ''.parse() == '', "Empty string parses to exactly the empty string"

test "#startsWith", ->
  ok "cool".startsWith("coo")
  equals "cool".startsWith("oo"), false

test "#titleize", ->
  equals "man from the boondocks".titleize(), "Man From The Boondocks"
  equals "x-men: the last stand".titleize(), "X Men: The Last Stand"

test "#toInt", ->
  equals "31.3".toInt(), 31
  equals "31.".toInt(), 31
  
  
  equals "09".toInt(), 31

test "#underscore", ->
  equals "Pro-tip".underscore(), "pro_tip"
  equals "Bullet".underscore(), "bullet"
  equals "FPSCounter".underscore(), "fps_counter"

test "#withoutExtension", ->
  equals "neat.png".withoutExtension(), "neat"
  equals "not a file".withoutExtension(), "not a file"

module()

