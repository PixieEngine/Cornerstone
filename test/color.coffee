module "Color"

test "default should be black", ->
  color = Color()

  ok color.equals
    r: -> 0
    g: -> 0
    b: -> 0 
    a: -> 0

test "should parse rgb", ->
  color = Color('rgb(3, 56, 174)')

  ok color.equals
    r: -> 3
    g: -> 56
    b: -> 174
    a: -> 1

test "should parse rgba", ->
  color = Color('rgb(4, 66, 134, 0.45)')

  ok color.equals
    r: -> 4
    g: -> 66
    b: -> 134
    a: -> 0.45

test "should parse rgba without leading 0 on alpha value", -> 
  color = Color('rgb(4, 66, 134, .33)')

  ok color.equals
    r: -> 4
    g: -> 66
    b: -> 134
    a: -> 0.33

test "should parse length 8 hex string", -> 
  color = Color('ae56f03a')

  ok color.equals
    r: -> 174
    g: -> 86
    b: -> 240
    a: -> 58 / 255.0

test "should parse length 8 hex string with leading #", ->
  color = Color('#001f34bb')

  ok color.equals
    r: -> 0
    g: -> 31
    b: -> 52
    a: -> 187 / 255.0

test "should parse length 6 hex string", -> 
  color = Color('1084ce')

  ok color.equals
    r: -> 16
    g: -> 132
    b: -> 206
    a: -> 1

test "should parse length 6 hex string with leading #", ->
  color = Color('#dfef12')

  ok color.equals
    r: -> 223
    g: -> 239
    b: -> 18
    a: -> 1

test "should parse length 4 hex string", ->   
  color = Color('b8f0')

  ok color.equals
    r: -> 187
    g: -> 136
    b: -> 255
    a: -> 0

test "should parse length 4 hex string with leading #", ->  
  color = Color('#ab87')

  ok color.equals
    r: -> 170
    g: -> 187
    b: -> 136
    a: -> 119 / 255.0

test "should parse length 3 hex string", ->   
  color = Color('a94')

  ok color.equals
    r: -> 170
    g: -> 153
    b: -> 68
    a: -> 1

test "should parse length 3 hex string with leading #", ->  
  color = Color('#3ef')

  ok color.equals
    r: -> 51
    g: -> 238
    b: -> 255
    a: -> 1  

test "should know what lavender blue is", ->
  color = Color("lavender blue")

  ok color.equals
    r: -> 139
    g: -> 136
    b: -> 248
    a: -> 1

test "should parse 'transparent'", ->
  color = Color("transparent")

  ok color.equals
    r: -> 0
    g: -> 0
    b: -> 0
    a: -> 0

test "should throw error if cannot find color", ->
  raises ->
    color = Color("asdf39402394")
  , "asdf39402394 is an unknown color"

test "should parse arrays", ->
  color = Color([1, 24, 101])

  ok color.equals
    r: -> 1
    g: -> 24
    b: -> 101
    a: -> 1

test "parse 3 or 4 number arguments", ->
  color = Color(4, 34, 102, 0.4)

  ok color.equals
    r: -> 4
    g: -> 34
    b: -> 102
    a: -> 0.4

test "should parse first argument array, second argument alpha", ->
  color = Color([4, 200, 43], 0.4)

  ok color.equals
    r: -> 4
    g: -> 200
    b: -> 43
    a: -> 0.4

test "should parse first argument string, second argument alpha", ->
  hexColor = Color("#1084ce", 0.5)
  rgbColor = Color("rgb(3, 90, 210)", 0.3)

  ok hexColor.equals
    r: -> 16
    g: -> 132
    b: -> 206
    a: -> 0.5

  ok rgbColor.equals
    r: -> 3
    g: -> 90
    b: -> 210
    a: -> 0.3 

test "should equal colors with the same rbga values", ->
  color1 = Color(4, 20, 100)
  color2 = Color('rgb(4, 20, 100)')
  color3 = Color('#041464')
  color4 = Color([4, 20, 100])

  ok color1.equals(color2)
  ok color1.equals(color3)
  ok color1.equals(color4)

  alpha1 = Color(51, 51, 51, 1)
  alpha2 = Color('rgba(51, 51, 51, 1)')
  alpha3 = Color('#333333ff')
  alpha4 = Color('#333f')
  alpha5 = Color([51,51,51,1])

  ok alpha1.equals(alpha2)
  ok alpha1.equals(alpha3)
  ok alpha1.equals(alpha4)
  ok alpha1.equals(alpha5)

test "should output proper toString", ->
  color = Color(5, 25, 125, 0.73)

  equals color.toString(), "rgba(5, 25, 125, 0.73)"

test "should output proper toHex", ->
  white = Color(255, 255, 255)
  black = Color(0, 0, 0)

  equals white.toHex(), "#ffffff"
  equals black.toHex(), "#000000"

test "should recognize an object with a channels array as a Color", ->
  red = Color(255, 0, 0)
  testColor = Color(red)

  ok testColor.equals
    r: -> 255
    g: -> 0
    b: -> 0
    a: -> 1

test "#toHsl", ->
  color = Color(123, 43, 98)
  hsl = color.toHsl()

  equals hsl[0], 319
  equals hsl[1].toFixed(2), "0.48"
  equals hsl[2].toFixed(2), "0.33"
  equals hsl[3], 1

test "#hslToRgb", ->
  color = Color(50, 10, 100)
  hsl = color.toHsl()
  rgb = color.hslToRgb(hsl)

  equals rgb.r(), color.r()
  equals rgb.g(), color.g()
  equals rgb.b(), color.b()

test "#lighten", ->
  color = Color(20, 45, 123)
  lightColor = color.lighten(0.1)

  equals lightColor.r(), 27
  equals lightColor.g(), 62
  equals lightColor.b(), 167

test "#darken", ->
  color = Color(34, 58, 29)
  darkColor = color.darken(0.1)

  equals darkColor.r(), 14 
  equals darkColor.g(), 24
  equals darkColor.b(), 12

test "Color.mix", ->
  color1 = Color(33, 55, 100)
  color2 = Color(50, 90, 200)

  mixedColor = Color.mix(color1, color2)

  ok mixedColor.equals
    r: -> 41
    g: -> 72
    b: -> 150

module()

