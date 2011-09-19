###*
Gives you some convenience methods for outputting data
while developing. 

@name Logging
@namespace

<code><pre>
  log "Testing123"
  info "Hey, this is happening"
  warn "Be careful, this might be a problem"
  error "Kaboom!"
</pre></code>
###

["log", "info", "warn", "error"].each (name) ->
  if typeof console != "undefined"
    (exports ? this)[name] = (message) ->
      if console[name]
        console[name](message)
  else
    (exports ? this)[name] = ->

