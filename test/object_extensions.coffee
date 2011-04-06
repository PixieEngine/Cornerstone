module "Object"
 
test "#isArray", ->
  a = [1,2,3]
  b = {
    blah: "blah"
    second: "another"
  }
  c = 5
  d = "string"
  
  ok a.isArray(), "an array should evaluate to an array"
  ok !b.isArray(), "an object should not evaluate to an array"
  ok !c.isArray(), "a number should not evaluate to an array"
  ok !d.isArray(), "a string should not evaluate to an array"
  
module()