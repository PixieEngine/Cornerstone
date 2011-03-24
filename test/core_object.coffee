module "Core"
 
test "#extend", ->
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

test "#attrAccessor", ->
  o = Core
    test: "my_val"
  
  o.attrAccessor("test")
    
  equal o.test(), "my_val"
  equal o.test("new_val"), o
  equal o.test(), "new_val"

test "#attrReader", ->
  o = Core
    test: "my_val"
  
  o.attrReader("test")
    
  equal o.test(), "my_val"
  equal o.test("new_val"), "my_val"
  equal o.test(), "my_val"

test "#include", ->
  o = Core
    test: "my_val"
    
  M = (I, self) ->
    self.attrReader "test"
    
    test2: "cool"
    
  o.include M
  
  equal o.test(), "my_val"
  equal o.test2, "cool"

module undefined

