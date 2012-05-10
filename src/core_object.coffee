###*
The Core class is used to add extended functionality to objects without
extending the object class directly. Inherit from Core to gain its utility
methods.

@name Core
@constructor

@param {Object} I Instance variables
###

Core = (I={}) ->
  self =
    ###*
    External access to instance variables. Use of this property should be avoided
    in general, but can come in handy from time to time.

    <code><pre>
    I =
      r: 255
      g: 0
      b: 100

    myObject = Core(I)

    # a bad idea most of the time, but it's 
    # pretty convenient to have available.
    myObject.I.r
    # => 255

    myObject.I.g
    # => 0

    myObject.I.b
    # => 100
    </pre></code>

    @name I
    @fieldOf Core#
    ###
    I: I

    ###*
    Generates a public jQuery style getter / setter method for each 
    String argument.

    <code><pre>
    myObject = Core
      r: 255
      g: 0
      b: 100

    myObject.attrAccessor "r", "g", "b"

    myObject.r(254)
    myObject.r()

    => 254
    </pre></code>

    @name attrAccessor
    @methodOf Core#
    ###
    attrAccessor: (attrNames...) ->
      attrNames.each (attrName) ->
        self[attrName] = (newValue) ->
          if newValue?
            I[attrName] = newValue
            return self
          else
            I[attrName]

    ###*
    Generates a public jQuery style getter method for each String argument.

    <code><pre>
    myObject = Core
      r: 255
      g: 0
      b: 100

    myObject.attrReader "r", "g", "b"

    myObject.r()
    => 255

    myObject.g()
    => 0

    myObject.b()
    => 100
    </pre></code>

    @name attrReader
    @methodOf Core#
    ###
    attrReader: (attrNames...) ->
      attrNames.each (attrName) ->
        self[attrName] = ->
          I[attrName]

    ###*
    Extends this object with methods from the passed in object. A shortcut for Object.extend(self, methods)

    <code><pre>
    I =
      x: 30
      y: 40
      maxSpeed: 5

    # we are using extend to give player
    # additional methods that Core doesn't have
    player = Core(I).extend
      increaseSpeed: ->
        I.maxSpeed += 1

    player.I.maxSpeed
    => 5

    player.increaseSpeed()

    player.I.maxSpeed
    => 6
    </pre></code>

    @name extend
    @methodOf Core#
    @see Object.extend
    @returns self
    ###
    extend: (options) ->
      Object.extend self, options

      return self

    ###*
    Includes a module in this object.

    <code><pre>
    myObject = Core()
    myObject.include(Bindable)

    # now you can bind handlers to functions
    myObject.bind "someEvent", ->
      alert("wow. that was easy.")
    </pre></code>

    @name include
    @methodOf Core#
    @param {Module} Module the module to include. A module is a constructor that takes two parameters, I and self, and returns an object containing the public methods to extend the including object with.
    ###
    include: (modules...) ->
      for Module in modules
        Module = Module.c if Module.isString?()
        self.extend Module(I, self)
      
      return self
