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
  equals color.r(), 4
  equals color.g(), 66
  equals color.b(), 134
  equals color.a(), 0.45

test "Color should parse rgba without leading 0 on alpha value", -> 
  color = Color('rgb(4, 66, 134, .33)')
  equals color.r(), 4
  equals color.g(), 66
  equals color.b(), 134
  equals color.a(), 0.33 

test "Color should parse length 6 hex string", -> 
  color = Color('ffffff')
  equals color.r(), 255 
  equals color.g(), 255
  equals color.b(), 255 
 
test "Color should parse length 6 hex string with leading #", ->
  color = Color('#ffffff')
  equals color.r(), 255
  equals color.g(), 255
  equals color.b(), 255
  
  color = Color('#3ef')
  equals color.r(), 51
  equals color.g(), 238
  equals color.b(), 255
  
  color = Color('a94')
  equals color.r(), 170
  equals color.g(), 153
  equals color.b(), 68
 
test "Color should know what Fuzzy Wuzzy Brown is", ->
  color = Color("Fuzzy Wuzzy Brown")
  equals color.r(), 196
  equals color.g(), 86
  equals color.b(), 85

