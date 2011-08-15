module "Object"

test "isArray", ->
  array = [1,2,3]
  object = {
    blah: "blah"
    second: "another"
  }
  number = 5
  string = "string"

  ok Object.isArray(array), "an array is an array"
  ok !Object.isArray(object), "an object is not an array"
  ok !Object.isArray(number), "a number is not an array"
  ok !Object.isArray(string), "a string is not array"

test "reverseMerge", ->
  object =
    test: true
    b: "b"

  Object.reverseMerge object,
    test: false
    c: "c"

  ok object.test
  equals object.c, "c"

test "extend", ->
  object =
    test: true
    b: "b"

  Object.extend object,
    test: false
    c: "c"

  equals object.test, false
  equals object.b, "b"
  equals object.c, "c"

module()

