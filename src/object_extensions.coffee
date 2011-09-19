###*
Checks whether an object is an array.

<code><pre>
Object.isArray([1, 2, 4])
# => true

Object.isArray({key: "value"})
# => false
</pre></code>

@name isArray
@methodOf Object
@param {Object} object The object to check for array-ness.
@returns {Boolean} A boolean expressing whether the object is an instance of Array 
###
Object.isArray = (object)->
  Object::toString.call(object) == '[object Array]'

###*
Merges properties from objects into target without overiding.
First come, first served.

<code><pre>
  I =
    a: 1
    b: 2
    c: 3

  Object.reverseMerge I,
    c: 6
    d: 4   

  I # => {a: 1, b:2, c:3, d: 4}
</pre></code>

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

<code><pre>
  I =
    a: 1
    b: 2
    c: 3

  Object.extend I,
    c: 6
    d: 4

  I

  # => {a: 1, b:2, c:6, d: 4}
</pre></code>

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

<code><pre>
object = {a: 1}

Object.isObject(object)
# => true
</pre></code>

@name isObject
@methodOf Object

@param {Object} object Maybe this guy is an object.
@returns {Boolean} true if this guy is an object.
###
Object.isObject = (object) ->
  Object.prototype.toString.call(object) == '[object Object]'

