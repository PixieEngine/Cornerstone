###*
Checks whether an object is an array.

    Object.isArray([1, 2, 4])
    # => true
    
    Object.isArray({key: "value"})
    # => false

@name isArray
@methodOf Object
@param {Object} object The object to check for array-ness.
@returns {Boolean} A boolean expressing whether the object is an instance of Array 
###
Object.isArray = (object) ->
  Object::toString.call(object) == "[object Array]"

###*
Checks whether an object is a string.

    Object.isString("a string")
    # => true
    
    Object.isString([1, 2, 4])
    # => false
    
    Object.isString({key: "value"})
    # => false

@name isString
@methodOf Object
@param {Object} object The object to check for string-ness.
@returns {Boolean} A boolean expressing whether the object is an instance of String 
###
Object.isString = (object) ->
  Object::toString.call(object) == "[object String]"

###*
Merges properties from objects into target without overiding.
First come, first served.

      I =
        a: 1
        b: 2
        c: 3
    
      Object.reverseMerge I,
        c: 6
        d: 4   
    
      I # => {a: 1, b:2, c:3, d: 4}

@name reverseMerge
@methodOf Object
@param {Object} target The object to merge the properties into.
@returns {Object} target
###
Object.reverseMerge = (target, objects...) ->
  for object in objects
    for name of object
      unless target.hasOwnProperty(name)
        target[name] = object[name]

  return target

###*
Merges properties from sources into target with overiding.
Last in covers earlier properties.

      I =
        a: 1
        b: 2
        c: 3
    
      Object.extend I,
        c: 6
        d: 4
    
      I # => {a: 1, b:2, c:6, d: 4}

@name extend
@methodOf Object
@param {Object} target The object to merge the properties into.
@returns {Object} target
###
Object.extend = (target, sources...) ->
  for source in sources
    for name of source
      target[name] = source[name]

  return target

###*
Helper method that tells you if something is an object.

    object = {a: 1}
    
    Object.isObject(object)
    # => true

@name isObject
@methodOf Object
@param {Object} object Maybe this guy is an object.
@returns {Boolean} true if this guy is an object.
###
Object.isObject = (object) ->
  Object.prototype.toString.call(object) == '[object Object]'

