Callback = (options, machine, block) ->
  self =   
    match: (from_state, to_state, event) ->
      if options.to && options.from
        if options.to == to_state && options.from == from_state
          return true
        else
          return false
      
      if (options.to == to_state) || (options.from == from_state) || (options.on == event.name)
        return true 
       
    run: (params) ->
      block?.apply(machine.object, params)
      
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
    
    all: -> callbacks
    
    before: -> callbacks.before
      
    after: -> callbacks.after
      
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

      return transition.perform() if transition 
      
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
  
Machine = (name, object, options, block) ->
  events = EventCollection()
  states = StateCollection()
  callbacks = CallbackCollection()
  
  machine_name = name
  
  internal_state = options && (if options.initial then options.initial else '')
  add_methods_to_object(name, object)
  
  if block
    block(self)
  return self

  add_methods_to_object: (name, object) ->
    object[name] = self.state()
    object[name+'_events'] = events.all()
    object[name+'_states'] = states.all()
    
  add_event_methods: (name, object, event) ->
    object[name] = ->
      return event.fire(arguments) 
    object['can_'+name] = ->
      return event.can_fire()
      
  set_state: (state) ->
    internal_state = state
    object[machine_name] = state
  
  self =  
    event: (name, block) ->
      event = events.add(name, this)
      add_event_methods(name, object, event)
      if block then block(event)
      
      return event
    before_transition: (options, block) ->
      callback = callbacks.add('before', options, this, block)
      
    after_transition: (options, block) ->
      callback = callbacks.add('after', options, this, block)
      
    state: ->
      return internal_state
      
State = (name) ->
  I = {}

  I.name = name;

  return I 


StateCollection = ->
  states = []

  self = 
    add: (name) ->
      if typeof name == 'string'
        state = State(name)
        states.push(state)
      else
        name.each (item) ->
          
        `for(var i=0;i<name.length;i++){
          this.add(name[i]);
        }`

    all: ->
      states
      
Transition = (machine, event, from, to, params) ->
  self =
    perform: ->
      self.before()
      machine.set_state(to)
      self.after()
      return true

    before: ->
      machine.callbacks.run('before', from, to, event, params)
    
    after: ->
      machine.callbacks.run('after', from, to, event, params)

    rollback: ->
      machine.set_state(this.from)

