# YO, THIS FILE IS JUST TEMPORARY
# The real one is at: https://github.com/STRd6/core

Core = (I={}, self={}) ->
  extend self,
    I: I

    attrAccessor: (attrNames...) ->
      attrNames.forEach (attrName) ->
        self[attrName] = (newValue) ->
          if arguments.length > 0
            I[attrName] = newValue

            return self
          else
            I[attrName]

      return self

    attrReader: (attrNames...) ->
      attrNames.forEach (attrName) ->
        self[attrName] = ->
          I[attrName]

      return self

    extend: (object) ->
      extend self, object

    include: (modules...) ->
      for Module in modules
        Module(I, self)

      return self

  return self

extend = (target, sources...) ->
  for source in sources
    for name of source
      target[name] = source[name]

  return target

global.Core = Core
