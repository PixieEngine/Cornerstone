Function::withBefore = (interception) -> 
  method = this
  () ->
    interception.apply this, arguments
    method.apply this, arguments
    
Function::withAfter = (interception) -> 
  method = this
  () ->
    result = method.apply this, arguments
    interception.apply this, arguments
    return result

