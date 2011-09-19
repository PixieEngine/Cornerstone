###*
Returns a copy of the array without null and undefined values.

<code><pre>
[null, undefined, 3, 3, undefined, 5].compact()
# => [3, 3, 5]
</pre></code>

@name compact
@methodOf Array#
@returns {Array} A new array that contains only the non-null values.
###
Array::compact = ->
  this.select (element) ->
    element?

###*
Creates and returns a copy of the array. The copy contains
the same objects.

<code><pre>
a = ["a", "b", "c"]
b = a.copy()

# their elements are equal
a[0] == b[0] && a[1] == b[1] && a[2] == b[2]
# => true

# but they aren't the same object in memory
a === b
# => false
</pre></code>

@name copy
@methodOf Array#
@returns {Array} A new array that is a copy of the array
###
Array::copy = ->
  this.concat()

###*
Empties the array of its contents. It is modified in place.

<code><pre>
fullArray = [1, 2, 3]
fullArray.clear()
fullArray
# => []
</pre></code>

@name clear
@methodOf Array#
@returns {Array} this, now emptied.
###
Array::clear = ->
  this.length = 0

  return this

###*
Flatten out an array of arrays into a single array of elements.

<code><pre>
[[1, 2], [3, 4], 5].flatten()
# => [1, 2, 3, 4, 5]

# won't flatten twice nested arrays. call
# flatten twice if that is what you want
[[1, 2], [3, [4, 5]], 6].flatten()
# => [1, 2, 3, [4, 5], 6]
</pre></code>

@name flatten
@methodOf Array#
@returns {Array} A new array with all the sub-arrays flattened to the top.
###
Array::flatten = ->
  this.inject [], (a, b) ->
    a.concat b

###*
Invoke the named method on each element in the array
and return a new array containing the results of the invocation.

<code><pre>
[1.1, 2.2, 3.3, 4.4].invoke("floor")
# => [1, 2, 3, 4]

['hello', 'world', 'cool!'].invoke('substring', 0, 3)
# => ['hel', 'wor', 'coo']
</pre></code>

@param {String} method The name of the method to invoke.
@param [arg...] Optional arguments to pass to the method being invoked.
@name invoke
@methodOf Array#
@returns {Array} A new array containing the results of invoking the named method on each element.
###
Array::invoke = (method, args...) ->
  this.map (element) ->
    element[method].apply(element, args)

###*
Randomly select an element from the array.

<code><pre>
[1, 2, 3].rand()
# => 2
</pre></code>

@name rand
@methodOf Array#
@returns {Object} A random element from an array
###
Array::rand = ->
  this[rand(this.length)]

###*
Remove the first occurrence of the given object from the array if it is
present. The array is modified in place.

<code><pre>
a = [1, 1, "a", "b"]
a.remove(1)
# => 1

a
# => [1, "a", "b"]
</pre></code>

@name remove
@methodOf Array#
@param {Object} object The object to remove from the array if present.
@returns {Object} The removed object if present otherwise undefined.
###
Array::remove = (object) ->
  index = this.indexOf(object)

  if index >= 0
    this.splice(index, 1)[0]
  else
    undefined

###*
Returns true if the element is present in the array.

<code><pre>
["a", "b", "c"].include("c")
# => true

[40, "a"].include(700)
# => false
</pre></code>

@name include
@methodOf Array#
@param {Object} element The element to check if present.
@returns {Boolean} true if the element is in the array, false otherwise.
###
Array::include = (element) ->
  this.indexOf(element) != -1

###*
Call the given iterator once for each element in the array,
passing in the element as the first argument, the index of 
the element as the second argument, and <code>this</code> array as the
third argument.

<code><pre>
word = ""
indices = []
["r", "a", "d"].each (letter, index) ->
  word += letter
  indices.push(index)

# => ["r", "a", "d"]

word
# => "rad"

indices
# => [0, 1, 2]
</pre></code>

@name each
@methodOf Array#
@param {Function} iterator Function to be called once for each element in the array.
@param {Object} [context] Optional context parameter to be used as `this` when calling the iterator function.
@returns {Array} this to enable method chaining.
###
Array::each = (iterator, context) ->
  if this.forEach
    this.forEach iterator, context
  else
    for element, i in this
      iterator.call context, element, i, this

  return this

###*
Call the given iterator once for each element in the array, 
passing in the element as the first argument, the index of 
the element as the second argument, and `this` array as the
third argument.

<code><pre>
[1, 2, 3].map (number) ->
  number * number

# => [1, 4, 9]
</pre></code>

@name map
@methodOf Array#
@param {Function} iterator Function to be called once for each element in the array.
@param {Object} [context] Optional context parameter to be used as `this` when calling the iterator function.
@returns {Array} An array of the results of the iterator function being called on the original array elements.
###
Array::map ||= (iterator, context) ->
  results = []

  for element, i in this
    results.push iterator.call(context, element, i, this)

  results

###*
Call the given iterator once for each pair of objects in the array.

<code><pre>
[1, 2, 3, 4].eachPair (a, b) ->
  # 1, 2
  # 1, 3
  # 1, 4
  # 2, 3
  # 2, 4
  # 3, 4
</pre></code>

@name eachPair
@methodOf Array#
@param {Function} iterator Function to be called once for each pair of elements in the array.
@param {Object} [context] Optional context parameter to be used as `this` when calling the iterator function.
###
Array::eachPair = (iterator, context) ->
  length = this.length
  i = 0
  while i < length
    a = this[i]
    j = i + 1
    i += 1

    while j < length
      b = this[j]
      j += 1

      iterator.call context, a, b

###*
Call the given iterator once for each element in the array,
passing in the element as the first argument and the given object
as the second argument. Additional arguments are passed similar to
<code>each</code>.

@see Array#each
@name eachWithObject
@methodOf Array#
@param {Object} object The object to pass to the iterator on each visit.
@param {Function} iterator Function to be called once for each element in the array.
@param {Object} [context] Optional context parameter to be used as `this` when calling the iterator function.
@returns {Array} this
###
Array::eachWithObject = (object, iterator, context) ->
  this.each (element, i, self) ->
    iterator.call context, element, object, i, self

  return object

###*
Call the given iterator once for each group of elements in the array,
passing in the elements in groups of n. Additional argumens are
passed as in each.

<code><pre>
results = []
[1, 2, 3, 4].eachSlice 2, (slice) ->
  results.push(slice)
# => [1, 2, 3, 4]

results
# => [[1, 2], [3, 4]]
</pre></code>

@see Array#each
@name eachSlice
@methodOf Array#
@param {Number} n The number of elements in each group.
@param {Function} iterator Function to be called once for each group of elements in the array.
@param {Object} [context] Optional context parameter to be used as `this` when calling the iterator function.
@returns {Array} this
###
Array::eachSlice = (n, iterator, context) ->
  if n > 0
    len = (this.length / n).floor()
    i = -1

    while ++i < len
      iterator.call(context, this.slice(i*n, (i+1)*n), i*n, this)

  return this

###*
Returns a new array with the elements all shuffled up.

<code><pre>
a = [1, 2, 3]

a.shuffle()
# => [2, 3, 1]

a # => [1, 2, 3]
</pre></code>

@name shuffle
@methodOf Array#
@returns {Array} A new array that is randomly shuffled.
###
Array::shuffle = ->
  shuffledArray = []

  this.each (element) ->
    shuffledArray.splice(rand(shuffledArray.length + 1), 0, element)

  return shuffledArray

###*
Returns the first element of the array, undefined if the array is empty.

<code><pre>
["first", "second", "third"].first()
# => "first"
</pre></code>

@name first
@methodOf Array#
@returns {Object} The first element, or undefined if the array is empty.
###
Array::first = ->
  this[0]

###*
Returns the last element of the array, undefined if the array is empty.

<code><pre>
["first", "second", "third"].last()
# => "third"
</pre></code>

@name last
@methodOf Array#
@returns {Object} The last element, or undefined if the array is empty.
###
Array::last = ->
  this[this.length - 1]

###*
Returns an object containing the extremes of this array.

<code><pre>
[-1, 3, 0].extremes()
# => {min: -1, max: 3}
</pre></code>

@name extremes
@methodOf Array#
@param {Function} [fn] An optional funtion used to evaluate each element to calculate its value for determining extremes.
@returns {Object} {min: minElement, max: maxElement}
### 
Array::extremes = (fn) ->
  fn ||= (n) -> n

  min = max = undefined
  minResult = maxResult = undefined

  this.each (object) ->
    result = fn(object)

    if min?
      if result < minResult
        min = object
        minResult = result
    else
      min = object
      minResult = result

    if max?
      if result > maxResult
        max = object
        maxResult = result
    else
      max = object
      maxResult = result

  min: min
  max: max

###*
Pretend the array is a circle and grab a new array containing length elements. 
If length is not given return the element at start, again assuming the array 
is a circle.

<code><pre>
[1, 2, 3].wrap(-1)
# => 3

[1, 2, 3].wrap(6)
# => 1

["l", "o", "o", "p"].wrap(0, 16)
# => ["l", "o", "o", "p", "l", "o", "o", "p", "l", "o", "o", "p", "l", "o", "o", "p"]
</pre></code>

@name wrap
@methodOf Array#
@param {Number} start The index to start wrapping at, or the index of the sole element to return if no length is given.
@param {Number} [length] Optional length determines how long result array should be.
@returns {Object} or {Array} The element at start mod array.length, or an array of length elements, starting from start and wrapping.
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
Partitions the elements into two groups: those for which the iterator returns
true, and those for which it returns false.

@name partition
@methodOf Array#
@param {Function} iterator
@param {Object} [context] Optional context parameter to be used as `this` when calling the iterator function.
@returns {Array} An array in the form of [trueCollection, falseCollection]
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
Return the group of elements for which the return value of the iterator is true.

@name select
@methodOf Array#
@param {Function} iterator The iterator receives each element in turn as the first agument.
@param {Object} [context] Optional context parameter to be used as `this` when calling the iterator function.
@returns {Array} An array containing the elements for which the iterator returned true.
###
Array::select = (iterator, context) ->
  return this.partition(iterator, context)[0]

###*
Return the group of elements that are not in the passed in set.

@name without
@methodOf Array#
@param {Array} values List of elements to exclude.
@returns {Array} An array containing the elements that are not passed in.
###
Array::without = (values) ->
  this.reject (element) ->
    values.include(element)

###*
Return the group of elements for which the return value of the iterator is false.

@name reject
@methodOf Array#

@param {Function} iterator The iterator receives each element in turn as 
the first agument.
@param {Object} [context] Optional context parameter to be
used as `this` when calling the iterator function.

@type Array
@returns An array containing the elements for which the iterator returned false.
###
Array::reject = (iterator, context) ->
  this.partition(iterator, context)[1]

###*
Combines all elements of the array by applying a binary operation.
for each element in the arra the iterator is passed an accumulator 
value (memo) and the element.

@name inject
@methodOf Array#

@type Object
@returns The result of a
###
Array::inject = (initial, iterator) ->
  this.each (element) ->
    initial = iterator(initial, element)

  return initial

###*
Add all the elements in the array.

@name sum
@methodOf Array#

@type Number
@returns The sum of the elements in the array.
###
Array::sum = ->
  this.inject 0, (sum, n) ->
    sum + n

###*
Multiply all the elements in the array.

@name product
@methodOf Array#

@type Number
@returns The product of the elements in the array.
###
Array::product = ->
  this.inject 1, (product, n) ->
    product * n

Array::zip = (args...) ->
  this.map (element, index) ->   
    output = args.map (arr) ->
      arr[index]

    output.unshift(element)

    return output

