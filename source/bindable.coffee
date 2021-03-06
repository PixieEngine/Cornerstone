###*
Bindable module.

    player = Core
      x: 5
      y: 10

    player.bind "update", ->
      updatePlayer()
    # => Uncaught TypeError: Object has no method 'bind'

    player.include(Bindable)

    player.bind "update", ->
      updatePlayer()
    # => this will call updatePlayer each time through the main loop

@name Bindable
@module
@constructor
###
Bindable = (I={}, self=Core(I)) ->
  eventCallbacks = {}

  self.extend
    bind: (args...) ->
      self.on(args...)

    unbind: (args...) ->
      self.off(args...)

    ###*
    Adds a function as an event listener.

        # this will call coolEventHandler after
        # yourObject.trigger "someCustomEvent" is called.
        yourObject.on "someCustomEvent", coolEventHandler

        #or
        yourObject.on "anotherCustomEvent", ->
          doSomething()

    @name on
    @methodOf Bindable#
    @param {String} event The event to listen to.
    @param {Function} callback The function to be called when the specified event
    is triggered.
    ###
    on: (namespacedEvent, callback) ->
      [event, namespace] = namespacedEvent.split(".")

      # HACK: Here we annotate the callback function with namespace metadata
      # This will probably lead to some strange edge cases, but should work fine
      # for simple cases.
      if namespace
        callback.__PIXIE ||= {}
        callback.__PIXIE[namespace] = true

      eventCallbacks[event] ||= []
      eventCallbacks[event].push(callback)

      return this

    ###*
    Removes a specific event listener, or all event listeners if
    no specific listener is given.

        #  removes the handler coolEventHandler from the event
        # "someCustomEvent" while leaving the other events intact.
        yourObject.off "someCustomEvent", coolEventHandler

        # removes all handlers attached to "anotherCustomEvent"
        yourObject.off "anotherCustomEvent"

    @name off
    @methodOf Bindable#
    @param {String} event The event to remove the listener from.
    @param {Function} [callback] The listener to remove.
    ###
    off: (namespacedEvent, callback) ->
      [event, namespace] = namespacedEvent.split(".")

      if event
        eventCallbacks[event] ||= []

        if namespace
          # Select only the callbacks that do not have this namespace metadata
          eventCallbacks[event] = eventCallbacks.select (callback) ->
            !callback.__PIXIE?[namespace]?

        else
          if callback
            eventCallbacks[event].remove(callback)
          else
            eventCallbacks[event] = []
      else if namespace
        # No event given
        # Select only the callbacks that do not have this namespace metadata
        # for any events bound
        for key, callbacks of eventCallbacks
          eventCallbacks[key] = callbacks.select (callback) ->
            !callback.__PIXIE?[namespace]?

      return this

    ###*
    Calls all listeners attached to the specified event.

        # calls each event handler bound to "someCustomEvent"
        yourObject.trigger "someCustomEvent"

    @name trigger
    @methodOf Bindable#
    @param {String} event The event to trigger.
    @param {Array} [parameters] Additional parameters to pass to the event listener.
    ###
    trigger: (event, parameters...) ->
      callbacks = eventCallbacks[event]

      if callbacks && callbacks.length
        self = this

        callbacks.each (callback) ->
          callback.apply(self, parameters)

(global ? this)["Bindable"] = Bindable
