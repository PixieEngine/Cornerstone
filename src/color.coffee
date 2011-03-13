(->
  rgbParser = /^rgba?\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3}),?\s*(\d\.?\d*)?\)$/

  parseColor = (colorString) ->
    false if !colorString || colorString == 'transparent'

    bits = rgbParser.exec(colorString)
    return [
      toHex(bits[1])
      toHex(bits[2])
      toHex(bits[3])
    ].join('').toUpperCase()

  window.Color = (color) ->
    parsedColor = null

    if color[0] != "#"
      parsedColor = "#" + (parseColor(color) || "FFFFFF")
    else
      parsedColor = color

    channels =
      color = parseColor(color)

      r: parseInt(color[1])
      g: parseInt(color[2])
      b: parseInt(color[3])
      a: parseFloat(color[4]) || 1

    self =
      channels: channels

      equals: (other) ->
        return
          other.channels.r == channels.r &&
          other.channels.g == channels.g &&
          other.channels.b == channels.b &&
          other.channels.a = channels.a

      toHex: (bits) ->
        s = parseInt(bits).toString(16)

        s = '0' + s if s.length == 1

      rgba: ->
        return "rgba(#{channels.r}, #{channels.g}, #{channels.b}, #{channels.a})"

      toString: ->
        return (if channels.a == 1 then self.toHex() else self.rgba())

    return self
)()
