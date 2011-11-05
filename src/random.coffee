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
  @returns {Number} A random integer from 0 to n - 1 if n is given. If n is not given, a random float between 0 and 1. 
  ###
  (exports ? this)["rand"] = (n) -> 
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
  (exports ? this)["signedRand"] = (n) ->
    if n
      (n * Math.random()) - (n / 2)
    else
      Math.random() - 0.5

)()

