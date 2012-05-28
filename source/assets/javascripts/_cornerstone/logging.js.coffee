###*
@name Logging
@namespace

Gives you some convenience methods for outputting data while developing. 

      log "Testing123"
      info "Hey, this is happening"
      warn "Be careful, this might be a problem"
      error "Kaboom!"
###

["log", "info", "warn", "error"].each (name) ->
  if typeof console != "undefined"
    (exports ? this)[name] = (args...) ->
      if console[name]
        console[name](args...)
  else
    (exports ? this)[name] = ->
