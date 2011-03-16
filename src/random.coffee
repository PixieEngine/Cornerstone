window.Random =
  angle: ->
    rand() * Math.TAU
  often: ->
    return rand(3)
  sometimes: ->
    !rand(3)

