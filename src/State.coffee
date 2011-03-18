Callback = (options, machine, block)
  self =   
    match: (from_state, to_state, event) ->
      if options.to && options.from
        if options.to == to_state && options.from == from_state
          return true
        else
          return false
      
      if options.to == to_state
        return true
      
      if options.from == from_state
        return true
        
      if options.on == event.name
        return true
        
    run: (params) ->
      if block
        block.apply(machine.object, params)
      if options.run
        options.run.apply(machine.object, params)
      
  self
  
CallbackCollection = ->
  callbacks = []
  callbacks.before = []
  callbacks.after = []
  
  self =
    add: (type, options, machine, block) ->
      callback = Callback(options, machine, block)
      callbacks[type].push callback
    
    all: ->
      callbacks
    
    before: ->
      callbacks.before
      
    after:
      callbacks.after
      
    run: (type, from_state, to_state, event, params) ->
      localCallbacks = callbacks[type]
      
      callbacks.each (callback) ->
        if callback.match(from_state, to_state, event)
          callback.run(params)
      
  self
