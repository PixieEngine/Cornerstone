["log", "info", "warn", "error"].each (name) ->
  if typeof console != "undefined"
    (exports ? this)[name] = (message) ->
      if console[name]
        console[name](message)
  else
    (exports ? this)[name] = ->

