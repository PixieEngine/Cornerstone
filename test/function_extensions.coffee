suite "Function"

test "#once", ->
  score = 0

  addScore = ->
    score += 100

  onceScore = addScore.once()

  100.times ->
    onceScore()

  equals score, 100

test ".identity", ->
  I = Function.identity

  [0, 1, true, false, null, undefined].each (x) ->
    equals I(x), x

test "#returning", ->
  x = 0
  sideEffectsAdd = (a) ->
    x += a

  returnValue = sideEffectsAdd.returning(-1)(4)

  equals x, 4
  equals returnValue, -1

test "#debounce", (done) ->
  fn = (-> ok true; done()).debounce(50)

  # Though called multiple times the function is only triggered once
  fn()
  fn()
  fn()

test "#delay", (done) ->
  fn = (x, y) ->
    equals x, 3
    equals y, "testy"
    done()

  fn.delay 25, 3, "testy"

test "#defer", (done) ->
  fn = (x) ->
    equals x, 3
    done()

  fn.defer 3

suite()

