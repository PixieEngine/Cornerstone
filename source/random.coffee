( ->
  root = global ? window

  ###*
  @name Random
  @namespace Some useful methods for generating random things.
  ###
  root["Random"] =
    ###*
    Returns a random angle, uniformly distributed, between 0 and 2pi.

    @name angle
    @methodOf Random
    @returns {Number} A random angle between 0 and 2pi
    ###
    angle: ->
      rand() * Math.TAU

    ###*
    Returns a random angle between the given angles.

    @name angleBetween
    @methodOf Random
    @returns {Number} A random angle between the angles given.
    ###
    angleBetween: (min, max) ->
      rand() * (max - min) + min

    ###*
    Returns a random color.

    @name color
    @methodOf Random
    @returns {Color} A random color
    ###
    color: ->
      Color.random()

  ###*
  Returns random integers from [0, n) if n is given.
  Otherwise returns random float between 0 and 1.

  @name rand
  @methodOf window
  @param {Number} n
  @returns {Number} A random integer from 0 to n - 1 if n is given. If n is not given, a random float between 0 and 1.
  ###
  root["rand"] = (n) ->
    if n
      Math.floor(n * Math.random())
    else
      Math.random()

  ###*
  Returns random float from [-n / 2, n / 2] if n is given.
  Otherwise returns random float between -0.5 and 0.5.

  @name signedRand
  @methodOf window
  @param {Number} n
  @returns {Number} A random float from -n / 2 to n / 2 if n is given. If n is not given, a random float between -0.5 and 0.5.
  ###
  root["signedRand"] = (n) ->
    if n
      (n * Math.random()) - (n / 2)
    else
      Math.random() - 0.5

)()
