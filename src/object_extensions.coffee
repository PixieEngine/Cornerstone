###*
* Checks whether an object is an array.
*
* @type Object
* @returns A boolean expressing whether the object is an instance of Array 
###

Object.isArray = (object)->
  Object::toString.call(object) == '[object Array]'

