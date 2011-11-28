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

asyncTest "#debounce", 1, ->
  fn = (-> ok true; start()).debounce(50)

  # Though called multiple times the function is only triggered once
  fn()
  fn()
  fn()

module()

