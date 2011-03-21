###*
* Creates and returns a copy of the array. The copy contains
* the same objects.
*
* @type Array
* @returns A new array that is a copy of the array
###
Array::copy = ->
  this.concat()


###*
* Empties the array of its contents. It is modified in place.
*
* @type Array
* @returns this, now emptied.
###
Array::clear = ->
  this.length = 0
  
  return this

###*
* Invoke the named method on each element in the array
* and return a new array containing the results of the invocation.
*
<code><pre>
  [1.1, 2.2, 3.3, 4.4].invoke("floor")
  => [1, 2, 3, 4]

  ['hello', 'world', 'cool!'].invoke('substring', 0, 3)
  => ['hel', 'wor', 'coo']
</pre></code>
*
* @param {String} method The name of the method to invoke.
* @param [arg...] Optional arguments to pass to the method being invoked.
*
* @type Array
* @returns A new array containing the results of invoking the 
* named method on each element.
###
Array::invoke = (method) ->
  args = Array.prototype.slice.call(arguments, 1)
  
  this.map (element) ->
    element[method].apply(element, args)

###*
* Randomly select an element from the array.
*
* @returns A random element from an array
###
Array::rand = ->
  this[rand(this.length)]

###*
* Remove the first occurance of the given object from the array if it is
* present.
*
* @param {Object} object The object to remove from the array if present.
* @returns The removed object if present otherwise undefined.
###
Array::remove = (object) ->
  index = this.indexOf(object)
  
  if index >= 0
    this.splice(index, 1)[0]
  else
    undefined

###*
* Returns true if the element is present in the array.
*
* @param {Object} element The element to check if present.
* @returns true if the element is in the array, false otherwise.
* @type Boolean
###
Array::include = (element) ->
  this.indexOf(element) != -1


###*
 * Call the given iterator once for each element in the array,
 * passing in the element as the first argument, the index of 
 * the element as the second argument, and this array as the
 * third argument.
 *
 * @param {Function} iterator Function to be called once for 
 * each element in the array.
 * @param {Object} [context] Optional context parameter to be 
 * used as `this` when calling the iterator function.
 *
 * @returns `this` to enable method chaining.
###
Array::each = (iterator, context) ->
  if this.forEach
    this.forEach iterator, context
  else
    for element, i in this
      iterator.call context, element, i, this

  return this

Array::eachSlice = (n, iterator, context) ->
  if n > 0
    len = (this.length / n).ceil
    i = 0

    iterator.call(context, this.slice(i*n, (i+1)*n), i*n, this) while i++ < len

  return this

###*
 * Returns a new array with the elements all shuffled up.
 *
 * @returns A new array that is randomly shuffled.
 * @type Array
###
Array::shuffle = ->
  shuffledArray = []
  
  this.each (element) ->
    shuffledArray.splice(rand(shuffledArray.length + 1), 0, element)
  
  return shuffledArray


###*
 * Returns the first element of the array, undefined if the array is empty.
 *
 * @returns The first element, or undefined if the array is empty.
 * @type Object
###
Array::first = ->
  this[0]

###*
 * Returns the last element of the array, undefined if the array is empty.
 *
 * @returns The last element, or undefined if the array is empty.
 * @type Object
###
Array::last = ->
  this[this.length - 1]

###*
 * Pretend the array is a circle and grab a new array containing length elements. 
 * If length is not given return the element at start, again assuming the array 
 * is a circle.
 *
 * @param {Number} start The index to start wrapping at, or the index of the 
 * sole element to return if no length is given.
 * @param {Number} [length] Optional length determines how long result 
 * array should be.
 * @returns The element at start mod array.length, or an array of length elements, 
 * starting from start and wrapping.
 * @type Object or Array
###
Array::wrap = (start, length) ->
  if length?
    end = start + length
    i = start
    result = []

    result.push(this[i.mod(this.length)]) while i++ < end
  
    return result
  else
    return this[start.mod(this.length)]

###*
 * Partitions the elements into two groups: those for which the iterator returns
 * true, and those for which it returns false.
 * @param {Function} iterator
 * @param {Object} [context] Optional context parameter to be
 * used as `this` when calling the iterator function.
 *
 * @type Array
 * @returns An array in the form of [trueCollection, falseCollection]
###
Array::partition = (iterator, context) ->
  trueCollection = []
  falseCollection = []

  this.each (element) ->
    if iterator.call(context, element)
      trueCollection.push element
    else
      falseCollection.push element

  return [trueCollection, falseCollection]

###*
 * Return the group of elements for which the return value of the iterator is true.
 * 
 * @param {Function} iterator The iterator receives each element in turn as 
 * the first agument.
 * @param {Object} [context] Optional context parameter to be
 * used as `this` when calling the iterator function.
 *
 * @type Array
 * @returns An array containing the elements for which the iterator returned true.
###
Array::select = (iterator, context) ->
  return this.partition(iterator, context)[0]

###*
 * Return the group of elements that are not in the passed in set.
 * 
 * @param {Array} values List of elements to exclude.
 *
 * @type Array
 * @returns An array containing the elements that are not passed in.
###
Array.prototype.without = (values) ->
  this.reject (element) ->
    values.include(element)

###*
 * Return the group of elements for which the return value of the iterator is false.
 * 
 * @param {Function} iterator The iterator receives each element in turn as 
 * the first agument.
 * @param {Object} [context] Optional context parameter to be
 * used as `this` when calling the iterator function.
 *
 * @type Array
 * @returns An array containing the elements for which the iterator returned false.
###
Array::reject = (iterator, context) ->
  this.partition(iterator, context)[1]

Array::inject = (initial, iterator) ->
  this.each (element) ->
    initial = iterator(initial, element)

  return initial

Array::sum = ->
  this.inject 0, (sum, n) ->
    sum + n

