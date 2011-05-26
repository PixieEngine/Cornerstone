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

