module "Number"

test "#abs", ->
  equals (5).abs(), 5, "(5).abs() equals 5"
  equals (4.2).abs(), 4.2, "(4.2).abs() equals 4.2"
  equals (-1.2).abs(), 1.2, "(-1.2).abs() equals 1.2"
  equals (0).abs(), 0, "(0).abs() equals 0"
    
test "#ceil", ->
  equals (4.9).ceil(), 5, "(4.9).floor() equals 5"
  equals (4.2).ceil(), 5, "(4.2).ceil() equals 5"
  equals (-1.2).ceil(), -1, "(-1.2).ceil() equals -1"
  equals (3).ceil(), 3, "(3).ceil() equals 3"

test "#floor", ->
  equals (4.9).floor(), 4, "(4.9).floor() equals 4"
  equals (4.2).floor(), 4, "(4.2).floor() equals 4"
  equals (-1.2).floor(), -2, "(-1.2).floor() equals -2"
  equals (3).floor(), 3, "(3).floor() equals 3"

test "#round", ->
  equals (4.5).round(), 5, "(4.5).round() equals 5"
  equals (4.4).round(), 4, "(4.4).round() equals 4"

test "#sign", ->
  equals (5).sign(), 1, "Positive number's sign is 1"
  equals (-3).sign(), -1, "Negative number's sign is -1"
  equals (0).sign(), 0, "Zero's sign is 0"

test "#times", ->
  n = 5
  equals n.times($.noop), n, "returns n"

test "#times called correct amount", ->
  n = 5
  count = 0
  
  n.times -> count++
  
  equals n, count, "returns n"

  
test "#mod should have a positive result when used with a positive base and a negative number", ->
  n = -3

  equals n.mod(8), 5, "Should 'wrap' and be positive."

module undefined

