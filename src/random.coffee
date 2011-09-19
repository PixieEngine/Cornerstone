( ->
  ###*
  @name Random
  @namespace Some useful methods for generating random things.
  ###
  (exports ? this)["Random"] =
    ###*
    Returns a random angle, uniformly distributed, between 0 and 2pi.

    @name angle
    @methodOf Random
    @returns {Number} A random angle between 0 and 2pi
    ###
    angle: ->
      rand() * Math.TAU

    ###*
    Returns a random color.

    @name color
    @methodOf Random
    @returns {Color} A random color
    ###
    color: ->
      Color.random()

    ###*
    Happens often.

    @name often
    @methodOf Random
    ###
    often: ->
      return rand(3)

    ###*
    Happens sometimes.

    @name sometimes
    @methodOf Random
    ###
    sometimes: ->
      !rand(3)

  ###*
  Returns random integers from [0, n) if n is given.
  Otherwise returns random float between 0 and 1.

  @name rand
  @methodOf window

  @param {Number} n
  @type Number
  ###
  (exports ? this)["rand"] = (n) -> 
    if n
      Math.floor(n * Math.random())
    else
      Math.random()

)()

