module "Core"

test "#extend", ->
  o = Core()

  o.extend
    test: "jawsome"

  equals o.test, "jawsome"

  o.test = () ->
    equals calledBefore, true
    equals calledAfter, false

  calledBefore = false
  calledAfter = false

  o.extend
    before:
      test: () ->
        calledBefore = true
    after:
      test: () ->
        calledAfter = true

  o.test()

  equals calledBefore, true
  equals calledAfter, true

test "#attrAccessor", ->
  o = Core
    test: "my_val"

  o.attrAccessor("test")

  equals o.test(), "my_val"
  equals o.test("new_val"), o
  equals o.test(), "new_val"

test "#attrReader", ->
  o = Core
    test: "my_val"

  o.attrReader("test")

  equals o.test(), "my_val"
  equals o.test("new_val"), "my_val"
  equals o.test(), "my_val"

test "#include", ->
  o = Core
    test: "my_val"

  M = (I, self) ->
    self.attrReader "test"

    test2: "cool"

  o.include M

  equals o.test(), "my_val"
  equals o.test2, "cool"

module()

