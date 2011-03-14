test "Color default should be black", ->
  color = Color()
  equals color.r(), 0, "default red channel is 0"
  equals color.g(), 0, "default green channel is 0"
  equals color.b(), 0, "default blue channel is 0"
  equals color.a(), 0, "default alpha channel is 0"
 
test "Color should parse rgb", ->
  color = Color('rgb(3, 56, 174)')
  equals color.r(), 3, 'red channel should equal input red value'
  equals color.g(), 56, 'green channel should equal input green value'
  equals color.b(), 174, 'blue channel should equal input blue value'

test "Color should parse rgba", ->
  color = Color('rgb(4, 66, 134, 0.45)')
  equals color.r(), 4, 'red channel should equal input red value'
  equals color.g(), 66, 'green channel should equal input green value'
  equals color.b(), 134, 'blue channel should equal input blue value'
  equals color.a(), 0.45, 'alpha channel should equal input alpha value'
 
test "Color should parse hex starting with #", ->
  debugger
  color = Color('#ffffff')
  equals color.r(), 255, 'red channel should equal numeric equivalent of ff'
  equals color.g(), 255, 'green channel should equal numeric equivalent of ff'
  equals color.b(), 255, 'blue channel should equal numeric equivalent of ff'

