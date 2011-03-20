test "Storage", ->
  ok(Local)

test "Storage Local.set and Local.get", ->
  object =
    key: "test"
    cool: true
    num: 17
    sub:
      a: true
      b: 14
      c: "str"

  Local.set("__TEST", object)
  ret = Local.get("__TEST")
  equal ret.key, object.key
  equal ret.cool, object.cool
  equal ret.num, object.num
  equal ret.sub.a, object.sub.a
  equal ret.sub.b, object.sub.b
  equal ret.sub.c, object.sub.c

  Local.set("__TEST", 0)
  ret = Local.get("__TEST")
  equal ret, 0

  Local.set("__TEST", false)
  ret = Local.get("__TEST")
  equal ret, false

  Local.set("__TEST", "")
  ret = Local.get("__TEST")
  equal ret, ""

