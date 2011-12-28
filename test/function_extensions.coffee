module "Function"

test "#before and #after", ->
  calledAfter = false
  calledBefore = false

  testBefore = ->
    calledBefore = true

  testAfter = ->
    calledAfter = true

  testFn = ->
    ok calledBefore, "Called before function while inside test function"
    ok !calledAfter, "Have not called after function while inside test function"

  testFn = testFn.withBefore(testBefore).withAfter(testAfter)

  ok !calledBefore, "Haven't called before yet"
  ok !calledAfter, "Haven't called after yet"
  testFn()
  ok calledAfter, "Called after"

test "#returning", ->
  x = 0
  sideEffectsAdd = (a) ->
    x += a

  returnValue = sideEffectsAdd.returning(-1)(4)

  equals x, 4
  equals returnValue, -1

asyncTest "#debounce", 1, ->
  fn = (-> ok true; start()).debounce(50)

  # Though called multiple times the function is only triggered once
  fn()
  fn()
  fn()

asyncTest "#delay", 2, ->
  fn = (x, y) ->
    equals x, 3
    equals y, "testy"
    start()

  fn.delay 25, 3, "testy"

asyncTest "#defer", 1, ->
  fn = (x) -> 
    equals x, 3
    start()

  fn.defer 3

module()

