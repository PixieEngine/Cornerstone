###*
Checks whether an object is an array.
@name isArray
@methodOf Object

@param {Object} object The object to check for array-ness.
@type Boolean
@returns A boolean expressing whether the object is an instance of Array 
###
Object.isArray = (object)->
  Object::toString.call(object) == '[object Array]'

###*
Merges properties from objects into target without overiding.
First come, first served.
@name reverseMerge
@methodOf Object

@param {Object} target The object to merge the properties into.
@type Object
@returns target
###
Object.reverseMerge = (target, objects...) ->
  for object in objects
    for name of object
      unless target.hasOwnProperty(name)
        target[name] = object[name]

  return target

