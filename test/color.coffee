test "Color default color is black", ->
  color = Color()
  color.
  equals((5).abs(), 5, "(5).abs() equals 5")
  equals((4.2).abs(), 4.2, "(4.2).abs() equals 4.2")
  equals((-1.2).abs(), 1.2, "(-1.2).abs() equals 1.2")
  equals((0).abs(), 0, "(0).abs() equals 0")
