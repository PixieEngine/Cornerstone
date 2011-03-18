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
  
Event = (name, machine) ->
  guards = GuardsCollection()

  transition_for = (params) ->
    if can_fire(params)
      from = machine.state()
      to = guards.find_to_state(name, from, params)
      
      return Transition(machine, self, from, to, params)
    else
      return false
 
  self = 
    transition: (options) ->
      guards.add(name, machine.object, options)
      machine.states.add([options.from, options.to])
      
      return self
      
    can_fire: (params) ->
      if guards.match(name, machine.state(), params) then true else false
     
    fire: (params) ->
      transition = transition_for(params)
      if transition
        return transition.perform()
      else
        return false
       
  self
  
# just a thin wrapper on an array, probably not needed  
EventCollection = ->
  events = []
  
  self =
    add: (name, machine) ->
      event = Event(name, machine)
      events.push(event)
      return event
      
    all: ->
      events
  
  self
  
Guard = (name, object, options) ->
  I = 
    from: options.from
    to: options.to
    except: options.except
    options: options
    name: name
    object: object   
    
  self =
    match: (name, from, params) ->
      if name == I.name && match_from_state(I.from)
        if run_callbacks(params)
          true
        else
          false
      else
        false
        
    match_from_state: (from) ->
      if typeof I.from == 'string'
        if I.from == 'any'
          return check_exceptions(from)
        else
          return from == I.from
      else
        `for(var i=0; i < I.from.length; i++) {
          if(from == I.from[i]){
            return true
          }
        }
        return false;`
        
    check_exceptions: (from) ->
      return from != I.except
      
    run_callbacks: (params) ->
      success = true
      if I.options.when
        success = I.options.when.apply(I.object, params)
      if I.options.unless && success
        success = !I.options.unless.apply(I.object, params)
        
      return success
  
  self
  
GuardsCollection = ->
  guards = []
  last_match = null
  
  self =
    add: (name, object, options) ->
      guard = Guard(name, object, options)
      guards.push guard
      return guard
    
    all: ->
      guards
      
    match: (name, from, params) ->
      guards.each (guard) ->
        match = guard.match(name, from, params)
        if match
          last_match = match
          return guard
      
      return false
      
    find_to_state: (name, from, params) ->
      local_match = match(name, from, params)
      
      if local_match
        return match.to
  
  self
  
