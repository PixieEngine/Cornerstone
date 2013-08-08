module "Function"

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

test "#debounce", (done) ->
  fn = (-> ok true; done()).debounce(1)

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

module()

