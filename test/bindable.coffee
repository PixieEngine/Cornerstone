module "Bindable"

test "#bind and #trigger", 1, ->
  o = Object.extend({}, Bindable())

  o.bind("test", -> ok true)

  o.trigger("test")

test "Multiple bindings", 2, ->
  o = Object.extend({}, Bindable())

  o.bind("test", -> ok true)
  o.bind("test", -> ok true)

  o.trigger("test")

test "#trigger arguments", ->
  o = Object.extend({}, Bindable())

  param1 = "the message"
  param2 = 3

  o.bind "test", (p1, p2) ->
    equal(p1, param1)
    equal(p2, param2)

  o.trigger "test", param1, param2

test "#unbind", ->
  o = Object.extend({}, Bindable())

  callback = ->
    ok false

  o.bind "test", callback
  # Unbind specific event
  o.unbind "test", callback
  o.trigger "test"

  o.bind "test", callback
  # Unbind all events
  o.unbind "test"
  o.trigger "test"

test "#trigger namespace", 1, ->
  o = Object.extend({}, Bindable())
  o.bind "test.TestNamespace", ->
    ok true

  o.trigger ".TestNamespace"
  o.trigger "test"

  o.unbind ".TestNamespace", ->
  o.trigger "test"
  
test "#unbind namespaced", 1, ->
  o = Object.extend({}, Bindable())
  
  o.bind "test.TestNamespace", ->
    ok true

  o.trigger "test"

  o.unbind ".TestNamespace", ->
  o.trigger "test"

module()

