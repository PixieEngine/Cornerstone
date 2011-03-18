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
