test "Color default color is black", ->
  color = Color()
  equals color.channels.r, 0, "default red channel is 0"
  equals color.channels.g, 0, "default green channel is 0"
  equals color.channels.b, 0, "default blue channel is 0"
  equals color.channels.a, 0, "default alpha channel is 0"

test "Color should parse rgb", ->
  color = Color('rgb(34, 56, 74)')
  equals color.channels.r, 34, 'red channel equals input red value'
  equals color.channels.g, 56, 'green channel equals input green value'
  equals color.channels.b, 74, 'blue channel equals input blue value'
