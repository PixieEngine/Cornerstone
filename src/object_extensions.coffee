###*
Checks whether an object is an array.
@name isArray
@methodOf Object

@param {Object} object The object to check for array-ness.
@type Boolean
@returns A boolean expressing whether the object is an instance of Array 

<code><pre>
   Object.isArray([1, 2, 4])
=> true

   Object.isArray({key: "value"})
=> false
</pre></code>
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

<code><pre>
   I = {
     a: 1
     b: 2
     c: 3
   }

   Object.reverseMerge I, {
     c: 6
     d: 4
   }   

   I

=> {a: 1, b:2, c:3, d: 4}
</pre></code>
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
@name extend
@methodOf Object

@param {Object} target The object to merge the properties into.
@type Object
@returns target

<code><pre>
   I = {
     a: 1
     b: 2
     c: 3
   }

   Object.extend I, {
     c: 6
     d: 4
   }   

   I

=> {a: 1, b:2, c:6, d: 4}
</pre></code>
###
Object.extend = (target, sources...) ->
  for source in sources
    for name of source
      target[name] = source[name]

  return target

