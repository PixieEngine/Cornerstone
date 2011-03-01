test = "test"
 
Color = (I) ->
  I ||= {}

  $.reverseMerge I,
    r: 0
    g: 0
    b: 0
    h: 0
    s: 0
    l: 0
    v: 0
    dirty: true

  ###
  Recalculates all channels from the current RGB values.  If hue or
  saturation is undefined, its current value is kept.  If .dirty is
  false, this method is a no-op.
  ###
  recalc: ->
    if (I.dirty)

      max = Math.max(I.r, I.g, I.b)
      min = Math.min(I.r, I.g, I.b)
      equal = max - min < 0.000001  # lol floats

      if (equal)
        I.h ||= 0
      else if (max == I.r)
        I.h = 1/6 * (I.g - I.b) / (max - min) + 1
      else if (max == I.g)
        I.h = 1/6 * (I.b - I.r) / (max - min) + 1/3
      else if (max == I.b)
        I.h = 1/6 * (I.r - I.g) / (max - min) + 2/3

      I.h = I.h % 1

      I.l = (min + max) / 2

      if (equal)
        I.s ||= 0
      else if (I.l <= 1/2)
        I.s = (max - min) / (max + min)
      else
        I.s = (max - min) / (2 - (max + min))

      if (max == 0)
        I.t ||= 0
      else
        I.t = 1 - min / max

      I.v = max

      I.dirty = false  

  self =
    colorspaces: [
      name: 'RGB'
      channels: ['r', 'g', 'b']
      channelNames: ['Red', 'Green', 'Blue']
      
      , name: 'HSL'
      channels: ['h', 's', 'l']
      channelNames: ['Hue', 'Saturation', 'Lightness']

      , name: 'HSV'
      channels: ['h', 't', 'v']
      channelNames: ['Hue', 'Saturation', 'Value']
    ]

    ###
    Returns the color I object represents formatted as a typical
    HTML hex triple, i.e. #rrggbb.
    ###
    toHex: ->
      '#' + ('0' + Math.floor(I.r * 255 + 0.5).toString(16)).substr(-2) + ('0' + Math.floor(I.g * 255 + 0.5).toString(16)).substr(-2) + ('0' + Math.floor(I.b * 255 + 0.5).toString(16)).substr(-2)

    ###
    Sets the color to a random color.
    ###
    rand: ->
      I.r = rand()
      I.g = rand()
      I.b = rand()
      I.dirty = true

    ###
    Inverts the color.
    ###
    invert: ->
      I.r = 1 - I.r
      I.g = 1 - I.g
      I.b = 1 - I.b
      I.dirty = true

    ###
    Complements the color.
    ###
    complement: ->
      I.r = (I.r + 0.5) % 1
      I.g = (I.g + 0.5) % 1
      I.b = (I.b + 0.5) % 1
      I.dirty = true

    ###
    Parses a hex triplet.  Returns true on success.
    ###
    fromHex: (triplet) ->
      re = new RegExp(/^\s*#?([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})\s*$/i)
      rgb = re.exec(triplet)

      if (rgb == null)
        false

      I.r = parseInt(rgb[1], 16) / 255
      I.g = parseInt(rgb[2], 16) / 255
      I.b = parseInt(rgb[3], 16) / 255

      # Mark dirty, AND undefine saturation to force it to be recalculated
      I.dirty = true
      I.s = undefined
      I.t = undefined

      true

    ###
    Does some crazy number-crunching to convert the given hue, sat, and
    lightness to RGB.
    ###
    fromHsl: (h, s, l) ->
      # Modified slightly from http://en.wikipedia.org/wiki/HSL_and_HSV
      I.h = h
      I.s = s
      I.l = l

      q = 0

      if (l < 0.5)
        q = l * (1 + s)
      else
        q = l + s - (l * s)

      p = 2 * l - q

      t = {}

      t.r = (h + 1/3) % 1
      t.g = h
      t.b = (h + 2/3) % 1

      $.each(t, (channel, value) ->
        if (value < 1/6)
          t.channel = p + ((q - p) * 6 * value)
        else if (value < 1/2)
          t.channel = q
        else if (value < 2/3)
          t.channel = p + ((q - p) * 6 * (2/3 - value))
        else
          t.channel = p
      )

      I.dirty = true
      I.t = undefined

    fromHsv: (h, t, v) ->
      I.h = h
      I.t = t
      I.v = v

      h_idx = ((h * 6) % 6).floor()
      f = h * 6 - h_idx
      window.status = h + ' ' + h_idx + ' ' + f
      p = v * (1 - t)
      q = v * (1 - f * t)
      u = v * (1 - (1 - f) * t)

      switch h_idx
        when 0
          I.r = v
          I.g = u
          I.b = p
        when 1
          I.r = q
          I.g = v
          I.b = p
        when 2
          I.r = p
          I.g = v
          I.b = u
        when 3
          I.r = p
          I.g = q
          I.b = v
        when 4
          I.r = u
          I.g = p
          I.b = v
        when 5
          I.r = v
          I.g = p
          I.b = q

      I.dirty = true
      I.s = undefined

    clone: -> 
      other = {}
      $.each(self, (key, value) ->
        other[key] = value
      )

      self

    ###
    Returns a color object identical to this one, except that the hash
    of channels => values provided are applied.  These are applied in
    arbitrary order, so supplying channels from multiple colorspaces
    is undefined.
    ###
    assume: (assumptions) ->
      other = self.clone()
      $.each(assumptions, (key, value) ->
        other[key](value)
      )

      self

    r: (val) ->
      I.r = val
      I.dirty = true

    g: (val) ->
      I.g = val
      I.dirty = true

    b: (val) ->
      I.b = val
      I.dirty = true

    h: (val) ->
      recalc()
      fromHsl(val, I.s, I.l)

    s: (val) ->
      recalc()
      fromHsl(I.h, val, I.l)

    l: (val) ->
      recalc()
      fromHsl(I.h, I.s, val)

    t: (val) ->
      recalc()
      fromHsv(I.h, val, I.v)

    v: (val) ->
      recalc()
      fromHsv(I.h, I.t, val)
