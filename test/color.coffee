test "Color default color is black", ->
  color = Color("#000000")
  equals color.channels.r, 0, "default red channel is 0"
  equals color.channels.g, 0, "default green channel is 0"
  equals color.channels.b, 0, "default blue channel is 0"
  equals color.channels.a, 0, "default alpha channel is 0"

