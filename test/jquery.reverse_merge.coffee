module "jQuery.reverseMerge"
 
test "reverse merge", ->
  o = {
    exists: "cool"
  }
  
  $.reverseMerge o,
    another: "also cool"
    exists: "not cool"
    u: undefined
    
  equal o.exists, "cool"
  equal o.another, "also cool"
  equal o.u, undefined
  ok "u" of o

module()

