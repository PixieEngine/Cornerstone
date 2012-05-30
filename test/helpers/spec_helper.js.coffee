modName = null

window.ok = (x) ->
  expect(x).toBeTruthy()

window.equals = (x, y) ->
  expect(x).toEqual(y)

window.test = (name, fn) ->
  describe modName, fn

window.module = (name) ->
  modName = name

window.asyncTest = -> #TODO

