###*
 * Merges properties from objects into target without overiding.
 * First come, first served.
 * @return target
###
jQuery.extend
  reverseMerge: (target) ->
    for object, i in arguments
      continue if i == 0

      for name of object
        unless target.hasOwnProperty(name)
          target[name] = object[name]

    return target

