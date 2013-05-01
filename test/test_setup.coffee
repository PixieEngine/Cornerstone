ok = (expression, message) ->
  throw new Error(mesage) unless expression

equals = (a, b, message) ->
  throw new Error(message) unless a is b
