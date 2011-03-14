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

test "Color should parse length 8 hex string", -> 
  color = Color('ae56f03a')
  equals color.r(), 174 
  equals color.g(), 86
  equals color.b(), 240 
  equals color.a(), 58 / 255.0
 
test "Color should parse length 8 hex string with leading #", ->
  color = Color('#001f34bb')
  equals color.r(), 0
  equals color.g(), 31
  equals color.b(), 52 
  equals color.a(), 187 / 255.0
 
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

test "Color should parse length 4 hex string", ->   
  color = Color('b8f0')
  equals color.r(), 187
  equals color.g(), 136
  equals color.b(), 255
  equals color.a(), 0.0
 
test "Color should parse length 4 hex string with leading #", ->  
  color = Color('#ab87')
  equals color.r(), 170
  equals color.g(), 187
  equals color.b(), 136
  equals color.a(), 119 / 255.0 
 
test "Color should parse length 3 hex string", ->   
  color = Color('a94')
  equals color.r(), 170
  equals color.g(), 153
  equals color.b(), 68
 
test "Color should parse length 3 hex string with leading #", ->  
  color = Color('#3ef')
  equals color.r(), 51
  equals color.g(), 238
  equals color.b(), 255
  
test "Color should know what Fuzzy Wuzzy Brown is", ->
  color = Color("Fuzzy Wuzzy Brown")
  equals color.r(), 196
  equals color.g(), 86
  equals color.b(), 85

test "Color should parse arrays", ->
  color = Color([1, 24, 101])
  equals color.r(), 1
  equals color.g(), 24
  equals color.b(), 101 
  
test "Color parse 3 or 4 number arguments", ->
  color = Color(4, 34, 102, 0.4)
  equals color.r(), 4
  equals color.g(), 34
  equals color.b(), 102
  equals color.a(), 0.4
  
test "Color should parse first argument array, second argument alpha", ->
  color = Color([4, 200, 43], 0.4)
  equals color.r(), 4
  equals color.g(), 200
  equals color.b(), 43
  equals color.a(), 0.4
  
test "Color should parse first argument string, second argument alpha", ->
  hexColor = Color("#1084ce", 0.5)
  rgbColor = Color("rgb(3, 90, 210)", 0.3)
  equals hexColor.r(), 16
  equals hexColor.g(), 132
  equals hexColor.b(), 206
  equals hexColor.a(), 0.5
  
  equals rgbColor.r(), 3
  equals rgbColor.g(), 90
  equals rgbColor.b(), 210
  equals rgbColor.a(), 0.3
  
  
  
test "Color should equal colors with the same rbga values", ->
  color1 = Color(4, 20, 100)
  color2 = Color('rgb(4, 20, 100)')
  color3 = Color('#041464')
  color4 = Color([4, 20, 100])
  ok(color1.equals(color2))
  ok(color1.equals(color3))
  ok(color1.equals(color4))
  
  alpha1 = Color(51, 51, 51, 1)
  alpha2 = Color('rgba(51, 51, 51, 1)')
  alpha3 = Color('#333333ff')
  alpha4 = Color('#333f')
  alpha5 = Color([51,51,51,1])
  
  ok(alpha1.equals(alpha2))
  ok(alpha1.equals(alpha3))
  ok(alpha1.equals(alpha4))
  ok(alpha1.equals(alpha5))
    
test "Color should output proper toString", ->
  color = Color(5, 25, 125, 0.73)
  equals color.toString(), "rgba(5, 25, 125, 0.73)"
