module "Object"
 
test "#isArray", ->
  a = [1,2,3]
  
  ok a.isArray, "an array should evaluate as an array"
  
module()