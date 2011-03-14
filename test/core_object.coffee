test "Core#extend", ->
  o = Core()
  
  o.extend
    test: "jawsome"
    
  equal o.test, "jawsome"
  
  o.test = () ->
    equal calledBefore, true
    equal calledAfter, false
  
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
  
  equal calledBefore, true
  equal calledAfter, true

test "Core#attrAccessor", ->
  o = Core
    test: "my_val"
  
  o.attrAccessor("test")
    
  equal o.test(), "my_val"
  equal o.test("new_val"), o
  equal o.test(), "new_val"

test "Core#attrReader", ->
  o = Core
    test: "my_val"
  
  o.attrReader("test")
    
  equal o.test(), "my_val"
  equal o.test("new_val"), "my_val"
  equal o.test(), "my_val"

