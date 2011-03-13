###
test "Color default should be black", ->
  color = Color()
  equals color.channels.r, 0, "default red channel is 0"
  equals color.channels.g, 0, "default green channel is 0"
  equals color.channels.b, 0, "default blue channel is 0"
  equals color.channels.a, 0, "default alpha channel is 0"
###
 
test "Color should parse rgb", ->
  color = Color('rgb(34, 56, 74)')
  equals color.r, 34, 'red channel should equal input red value'
  equals color.g, 56, 'green channel should equal input green value'
  equals color.b, 74, 'blue channel should equal input blue value'

### 
test "Color should parse hex starting with #", ->
  color = Color('#ffffff')
  equals color.channels.r, 255, 'red channel should equal numeric equivalent of ff'
  equals color.channels.g, 255, 'green channel should equal numeric equivalent of ff'
  equals color.channels.b, 255, 'blue channel should equal numeric equivalent of ff'
###