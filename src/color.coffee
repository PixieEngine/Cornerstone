(->
  rgbParser = /^rgba?\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3}),?\s*(\d\.?\d*)?\)$/

  toHex = (bits) ->
    s = parseInt(bits).toString(16)

    s = '0' + s if s.length == 1 
 
  parseColor = (colorString) ->
    false if !colorString || colorString == 'transparent'

    bits = rgbParser.exec(colorString)
    return [
      toHex(bits[1])
      toHex(bits[2])
      toHex(bits[3])
    ].join('').toUpperCase()

  window.Color = (color) ->
    color ||= "rgba(0, 0, 0, 0)"
    
    parsedColor = null

    if color[0] != "#"
      parsedColor = "#" + (parseColor(color) || "FFFFFF")
    else
      parsedColor = parseColor(color)
      
    alpha = parsedColor[4]

    channels = [
      parseInt(parsedColor[1]) 
      parseInt(parsedColor[2])
      parseInt(parsedColor[3])
      if alpha? then parseFloat(alpha) else 0.0
    ]

    self =
      channels: channels

      equals: (other) ->
        return other.channels.r == channels.r &&
          other.channels.g == channels.g &&
          other.channels.b == channels.b &&
          other.channels.a = channels.a

      rgba: ->
        return "rgba(#{channels.r}, #{channels.g}, #{channels.b}, #{channels.a})"

      toString: ->
        return (if channels.a == 1 then toHex([channels.r, channels.g, channels.b]) else self.rgba())

    return self
)()
