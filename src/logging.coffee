$ ->
  ["log", "info", "warn", "error"].each (name) ->
    if typeof console != "undefined"
      window[name] = (message) ->
        if console[name]
          console[name](message)
    else
      window[name] = $.noop

