###*
The Core class is used to add extended functionality to objects without
extending the object class directly. Inherit from Core to gain its utility
methods.

@name Core
@constructor

@param {Object} I Instance variables
###

###*
@name I
@memberOf Core#
###

Core = (I) ->
  I ||= {}

  self =
    I: I

    ###*
    Generates a public jQuery style getter / setter method for each 
    String argument.

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

    @name attrReader
    @methodOf Core#
    ###
    attrReader: (attrNames...) ->
      attrNames.each (attrName) ->
        self[attrName] = ->
          I[attrName]

    ###*
    Extends this object with methods from the passed in object. `before` and 
    `after` are special option names that glue functionality before or after 
    existing methods.

    @name extend
    @methodOf Core#
    ###
    extend: (options) ->
      afterMethods = options.after
      beforeMethods = options.before

      delete options.after
      delete options.before

      $.extend self, options

      if beforeMethods
        $.each beforeMethods, (name, fn) ->
          self[name] = self[name].withBefore(fn)

      if afterMethods
        $.each afterMethods, (name, fn) ->
          self[name] = self[name].withAfter(fn)

      return self

    ###* 
    Includes a module in this object.

    @name include
    @methodOf Core#

    @param {Module} Module the module to include. A module is a constructor 
    that takes two parameters, I and self, and returns an object containing the 
    public methods to extend the including object with.
    ###
    include: (Module) ->
      self.extend Module(I, self)

