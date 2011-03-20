test "State events should check if event can be fired", ->
  ###
    animation = Core
      initialState: 'stand'
      
    animation.include(StateMachine)
      
    state = StateMachine car, { initial: 'parked' }, (machine) ->
      machine.event 'start', (event) ->
        event.transition({ from: 'parked', to: 'idling' })
      
      machine.event 'stop', (event) ->
        event.transition({ from: 'idling', to: 'parked' })
        
      ok car.can_start()
      ok !car.can_stop()
  ###

