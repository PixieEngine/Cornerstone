( ($) ->
  window.Random = $.extend window.Random,
    angle: ->
      rand() * Math.TAU
    often: ->
      return rand(3)
    sometimes: ->
      !rand(3)
      
  ###*
  Returns random integers from [0, n) if n is given.
  Otherwise returns random float between 0 and 1.

  @param {Number} n
  ###
  window.rand = (n) -> 
    if(n)
      Math.floor(n * Math.random())
    else
      Math.random()

)(jQuery)

