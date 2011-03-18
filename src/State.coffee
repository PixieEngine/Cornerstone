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
