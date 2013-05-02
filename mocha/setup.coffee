ok = (expression, message) ->
  throw new Error(mesage) unless expression

equal = equals = (a, b, message) ->
  throw new Error(message) unless a is b

