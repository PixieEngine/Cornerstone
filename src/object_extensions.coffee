###*
* Checks whether an object is an array.
*
* @type Object
* @returns A boolean expressing whether the object is an instance of Array 
###

Object::isArray = ->
  return Object.prototype.toString.call(this) == '[object Array]'