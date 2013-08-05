

/**
Checks whether an object is an array.

    Object.isArray([1, 2, 4])
    # => true

    Object.isArray({key: "value"})
    # => false

@name isArray
@methodOf Object
@param {Object} object The object to check for array-ness.
@returns {Boolean} A boolean expressing whether the object is an instance of Array
*/
var __slice = Array.prototype.slice;

Object.isArray = function(object) {
  return Object.prototype.toString.call(object) === "[object Array]";
};

/**
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
*/

Object.isString = function(object) {
  return Object.prototype.toString.call(object) === "[object String]";
};

/**
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
*/

Object.defaults = Object.reverseMerge = function() {
  var name, object, objects, target, _i, _len;
  target = arguments[0], objects = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
  for (_i = 0, _len = objects.length; _i < _len; _i++) {
    object = objects[_i];
    for (name in object) {
      if (!target.hasOwnProperty(name)) target[name] = object[name];
    }
  }
  return target;
};

/**
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
*/

Object.extend = function() {
  var name, source, sources, target, _i, _len;
  target = arguments[0], sources = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
  for (_i = 0, _len = sources.length; _i < _len; _i++) {
    source = sources[_i];
    for (name in source) {
      target[name] = source[name];
    }
  }
  return target;
};

/**
Helper method that tells you if something is an object.

    object = {a: 1}

    Object.isObject(object)
    # => true

@name isObject
@methodOf Object
@param {Object} object Maybe this guy is an object.
@returns {Boolean} true if this guy is an object.
*/

Object.isObject = function(object) {
  return Object.prototype.toString.call(object) === '[object Object]';
};

/**
Calculate the average value of an array. Returns undefined if some elements
are not numbers.

    [1, 3, 5, 7].average()
    # => 4

@name average
@methodOf Array#
@returns {Number} The average (arithmetic mean) of the list of numbers.
*/
var _base,
  __slice = Array.prototype.slice;

Array.prototype.average = function() {
  return this.sum() / this.length;
};

/**
Returns a copy of the array without null and undefined values.

    [null, undefined, 3, 3, undefined, 5].compact()
    # => [3, 3, 5]

@name compact
@methodOf Array#
@returns {Array} A new array that contains only the non-null values.
*/

Array.prototype.compact = function() {
  return this.select(function(element) {
    return element != null;
  });
};

/**
Creates and returns a copy of the array. The copy contains
the same objects.

    a = ["a", "b", "c"]
    b = a.copy()

    # their elements are equal
    a[0] == b[0] && a[1] == b[1] && a[2] == b[2]
    # => true

    # but they aren't the same object in memory
    a === b
    # => false

@name copy
@methodOf Array#
@returns {Array} A new array that is a copy of the array
*/

Array.prototype.copy = function() {
  return this.concat();
};

/**
Empties the array of its contents. It is modified in place.

    fullArray = [1, 2, 3]
    fullArray.clear()
    fullArray
    # => []

@name clear
@methodOf Array#
@returns {Array} this, now emptied.
*/

Array.prototype.clear = function() {
  this.length = 0;
  return this;
};

/**
Flatten out an array of arrays into a single array of elements.

    [[1, 2], [3, 4], 5].flatten()
    # => [1, 2, 3, 4, 5]

    # won't flatten twice nested arrays. call
    # flatten twice if that is what you want
    [[1, 2], [3, [4, 5]], 6].flatten()
    # => [1, 2, 3, [4, 5], 6]

@name flatten
@methodOf Array#
@returns {Array} A new array with all the sub-arrays flattened to the top.
*/

Array.prototype.flatten = function() {
  return this.inject([], function(a, b) {
    return a.concat(b);
  });
};

/**
Invoke the named method on each element in the array
and return a new array containing the results of the invocation.

    [1.1, 2.2, 3.3, 4.4].invoke("floor")
    # => [1, 2, 3, 4]

    ['hello', 'world', 'cool!'].invoke('substring', 0, 3)
    # => ['hel', 'wor', 'coo']

@param {String} method The name of the method to invoke.
@param [arg...] Optional arguments to pass to the method being invoked.
@name invoke
@methodOf Array#
@returns {Array} A new array containing the results of invoking the named method on each element.
*/

Array.prototype.invoke = function() {
  var args, method;
  method = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
  return this.map(function(element) {
    return element[method].apply(element, args);
  });
};

/**
Randomly select an element from the array.

    [1, 2, 3].rand()
    # => 2

@name rand
@methodOf Array#
@returns {Object} A random element from an array
*/

Array.prototype.rand = function() {
  return this[rand(this.length)];
};

/**
Remove the first occurrence of the given object from the array if it is
present. The array is modified in place.

    a = [1, 1, "a", "b"]
    a.remove(1)
    # => 1

    a
    # => [1, "a", "b"]

@name remove
@methodOf Array#
@param {Object} object The object to remove from the array if present.
@returns {Object} The removed object if present otherwise undefined.
*/

Array.prototype.remove = function(object) {
  var index;
  index = this.indexOf(object);
  if (index >= 0) {
    return this.splice(index, 1)[0];
  } else {
    return;
  }
};

/**
Returns true if the element is present in the array.

    ["a", "b", "c"].include("c")
    # => true

    [40, "a"].include(700)
    # => false

@name include
@methodOf Array#
@param {Object} element The element to check if present.
@returns {Boolean} true if the element is in the array, false otherwise.
*/

Array.prototype.include = function(element) {
  return this.indexOf(element) !== -1;
};

/**
Call the given iterator once for each element in the array,
passing in the element as the first argument, the index of
the element as the second argument, and <code>this</code> array as the
third argument.

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

@name each
@methodOf Array#
@param {Function} iterator Function to be called once for each element in the array.
@param {Object} [context] Optional context parameter to be used as `this` when calling the iterator function.
@returns {Array} this to enable method chaining.
*/

Array.prototype.each = function(iterator, context) {
  var element, i, _len;
  if (this.forEach) {
    this.forEach(iterator, context);
  } else {
    for (i = 0, _len = this.length; i < _len; i++) {
      element = this[i];
      iterator.call(context, element, i, this);
    }
  }
  return this;
};

/**
Call the given iterator once for each element in the array,
passing in the element as the first argument, the index of
the element as the second argument, and `this` array as the
third argument.

    [1, 2, 3].map (number) ->
      number * number
    # => [1, 4, 9]

@name map
@methodOf Array#
@param {Function} iterator Function to be called once for each element in the array.
@param {Object} [context] Optional context parameter to be used as `this` when calling the iterator function.
@returns {Array} An array of the results of the iterator function being called on the original array elements.
*/

(_base = Array.prototype).map || (_base.map = function(iterator, context) {
  var element, i, results, _len;
  results = [];
  for (i = 0, _len = this.length; i < _len; i++) {
    element = this[i];
    results.push(iterator.call(context, element, i, this));
  }
  return results;
});

/**
Call the given iterator once for each pair of objects in the array.

    [1, 2, 3, 4].eachPair (a, b) ->
      # 1, 2
      # 1, 3
      # 1, 4
      # 2, 3
      # 2, 4
      # 3, 4

@name eachPair
@methodOf Array#
@param {Function} iterator Function to be called once for each pair of elements in the array.
@param {Object} [context] Optional context parameter to be used as `this` when calling the iterator function.
*/

Array.prototype.eachPair = function(iterator, context) {
  var a, b, i, j, length, _results;
  length = this.length;
  i = 0;
  _results = [];
  while (i < length) {
    a = this[i];
    j = i + 1;
    i += 1;
    _results.push((function() {
      var _results2;
      _results2 = [];
      while (j < length) {
        b = this[j];
        j += 1;
        _results2.push(iterator.call(context, a, b));
      }
      return _results2;
    }).call(this));
  }
  return _results;
};

/**
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
*/

Array.prototype.eachWithObject = function(object, iterator, context) {
  this.each(function(element, i, self) {
    return iterator.call(context, element, object, i, self);
  });
  return object;
};

/**
Call the given iterator once for each group of elements in the array,
passing in the elements in groups of n. Additional argumens are
passed as in each.

    results = []
    [1, 2, 3, 4].eachSlice 2, (slice) ->
      results.push(slice)
    # => [1, 2, 3, 4]

    results
    # => [[1, 2], [3, 4]]

@see Array#each
@name eachSlice
@methodOf Array#
@param {Number} n The number of elements in each group.
@param {Function} iterator Function to be called once for each group of elements in the array.
@param {Object} [context] Optional context parameter to be used as `this` when calling the iterator function.
@returns {Array} this
*/

Array.prototype.eachSlice = function(n, iterator, context) {
  var i, len;
  if (n > 0) {
    len = (this.length / n).floor();
    i = -1;
    while (++i < len) {
      iterator.call(context, this.slice(i * n, (i + 1) * n), i * n, this);
    }
  }
  return this;
};

/**
Pipe the input through each function in the array in turn. For example, if you have a
list of objects you can perform a series of selection, sorting, and other processing
methods and then receive the processed list. This array must contain functions that
accept a single input and return the processed input. The output of the first function
is fed to the input of the second and so on until the final processed output is returned.

@name pipeline
@methodOf Array#

@param {Object} input The initial input to pass to the first function in the pipeline.
@returns {Object} The result of processing the input by each function in the array.
*/

Array.prototype.pipeline = function(input) {
  return this.inject(input, function(input, fn) {
    return fn(input);
  });
};

/**
Returns a new array with the elements all shuffled up.

    a = [1, 2, 3]

    a.shuffle()
    # => [2, 3, 1]

    a # => [1, 2, 3]

@name shuffle
@methodOf Array#
@returns {Array} A new array that is randomly shuffled.
*/

Array.prototype.shuffle = function() {
  var shuffledArray;
  shuffledArray = [];
  this.each(function(element) {
    return shuffledArray.splice(rand(shuffledArray.length + 1), 0, element);
  });
  return shuffledArray;
};

/**
Returns the first element of the array, undefined if the array is empty.

    ["first", "second", "third"].first()
    # => "first"

@name first
@methodOf Array#
@returns {Object} The first element, or undefined if the array is empty.
*/

Array.prototype.first = function() {
  return this[0];
};

/**
Returns the last element of the array, undefined if the array is empty.

    ["first", "second", "third"].last()
    # => "third"

@name last
@methodOf Array#
@returns {Object} The last element, or undefined if the array is empty.
*/

Array.prototype.last = function() {
  return this[this.length - 1];
};

/**
Returns an object containing the extremes of this array.

    [-1, 3, 0].extremes()
    # => {min: -1, max: 3}

@name extremes
@methodOf Array#
@param {Function} [fn] An optional funtion used to evaluate each element to calculate its value for determining extremes.
@returns {Object} {min: minElement, max: maxElement}
*/

Array.prototype.extremes = function(fn) {
  var max, maxResult, min, minResult;
  if (fn == null) fn = Function.identity;
  min = max = void 0;
  minResult = maxResult = void 0;
  this.each(function(object) {
    var result;
    result = fn(object);
    if (min != null) {
      if (result < minResult) {
        min = object;
        minResult = result;
      }
    } else {
      min = object;
      minResult = result;
    }
    if (max != null) {
      if (result > maxResult) {
        max = object;
        return maxResult = result;
      }
    } else {
      max = object;
      return maxResult = result;
    }
  });
  return {
    min: min,
    max: max
  };
};

Array.prototype.maxima = function(valueFunction) {
  if (valueFunction == null) valueFunction = Function.identity;
  return this.inject([-Infinity, []], function(memo, item) {
    var maxItems, maxValue, value;
    value = valueFunction(item);
    maxValue = memo[0], maxItems = memo[1];
    if (value > maxValue) {
      return [value, [item]];
    } else if (value === maxValue) {
      return [value, maxItems.concat(item)];
    } else {
      return memo;
    }
  }).last();
};

Array.prototype.maximum = function(valueFunction) {
  return this.maxima(valueFunction).first();
};

Array.prototype.minima = function(valueFunction) {
  var inverseFn;
  if (valueFunction == null) valueFunction = Function.identity;
  inverseFn = function(x) {
    return -valueFunction(x);
  };
  return this.maxima(inverseFn);
};

Array.prototype.minimum = function(valueFunction) {
  return this.minima(valueFunction).first();
};

/**
Pretend the array is a circle and grab a new array containing length elements.
If length is not given return the element at start, again assuming the array
is a circle.

    [1, 2, 3].wrap(-1)
    # => 3

    [1, 2, 3].wrap(6)
    # => 1

    ["l", "o", "o", "p"].wrap(0, 16)
    # => ["l", "o", "o", "p", "l", "o", "o", "p", "l", "o", "o", "p", "l", "o", "o", "p"]

@name wrap
@methodOf Array#
@param {Number} start The index to start wrapping at, or the index of the sole element to return if no length is given.
@param {Number} [length] Optional length determines how long result array should be.
@returns {Object} or {Array} The element at start mod array.length, or an array of length elements, starting from start and wrapping.
*/

Array.prototype.wrap = function(start, length) {
  var end, i, result;
  if (length != null) {
    end = start + length;
    i = start;
    result = [];
    while (i < end) {
      result.push(this[i.mod(this.length)]);
      i += 1;
    }
    return result;
  } else {
    return this[start.mod(this.length)];
  }
};

/**
Partitions the elements into two groups: those for which the iterator returns
true, and those for which it returns false.

    [evens, odds] = [1, 2, 3, 4].partition (n) ->
      n.even()

    evens
    # => [2, 4]

    odds
    # => [1, 3]

@name partition
@methodOf Array#
@param {Function} iterator
@param {Object} [context] Optional context parameter to be used as `this` when calling the iterator function.
@returns {Array} An array in the form of [trueCollection, falseCollection]
*/

Array.prototype.partition = function(iterator, context) {
  var falseCollection, trueCollection;
  trueCollection = [];
  falseCollection = [];
  this.each(function(element) {
    if (iterator.call(context, element)) {
      return trueCollection.push(element);
    } else {
      return falseCollection.push(element);
    }
  });
  return [trueCollection, falseCollection];
};

/**
Return the group of elements for which the return value of the iterator is true.

@name select
@methodOf Array#
@param {Function} iterator The iterator receives each element in turn as the first agument.
@param {Object} [context] Optional context parameter to be used as `this` when calling the iterator function.
@returns {Array} An array containing the elements for which the iterator returned true.
*/

Array.prototype.select = function(iterator, context) {
  return this.partition(iterator, context)[0];
};

/**
Return the group of elements that are not in the passed in set.

    [1, 2, 3, 4].without ([2, 3])
    # => [1, 4]

@name without
@methodOf Array#
@param {Array} values List of elements to exclude.
@returns {Array} An array containing the elements that are not passed in.
*/

Array.prototype.without = function(values) {
  return this.reject(function(element) {
    return values.include(element);
  });
};

/**
Return the group of elements for which the return value of the iterator is false.

@name reject
@methodOf Array#
@param {Function} iterator The iterator receives each element in turn as the first agument.
@param {Object} [context] Optional context parameter to be used as `this` when calling the iterator function.
@returns {Array} An array containing the elements for which the iterator returned false.
*/

Array.prototype.reject = function(iterator, context) {
  return this.partition(iterator, context)[1];
};

/**
Combines all elements of the array by applying a binary operation.
for each element in the arra the iterator is passed an accumulator
value (memo) and the element.

@name inject
@methodOf Array#
@returns {Object} The result of a
*/

Array.prototype.inject = function(initial, iterator) {
  this.each(function(element) {
    return initial = iterator(initial, element);
  });
  return initial;
};

/**
Add all the elements in the array.

    [1, 2, 3, 4].sum()
    # => 10

@name sum
@methodOf Array#
@returns {Number} The sum of the elements in the array.
*/

Array.prototype.sum = function() {
  return this.inject(0, function(sum, n) {
    return sum + n;
  });
};

/**
Multiply all the elements in the array.

    [1, 2, 3, 4].product()
    # => 24

@name product
@methodOf Array#
@returns {Number} The product of the elements in the array.
*/

Array.prototype.product = function() {
  return this.inject(1, function(product, n) {
    return product * n;
  });
};

/**
Merges together the values of each of the arrays with the values at the corresponding position.

    ['a', 'b', 'c'].zip([1, 2, 3])
    # => [['a', 1], ['b', 2], ['c', 3]]

@name zip
@methodOf Array#
@returns {Array} Array groupings whose values are arranged by their positions in the original input arrays.
*/

Array.prototype.zip = function() {
  var args;
  args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
  return this.map(function(element, index) {
    var output;
    output = args.map(function(arr) {
      return arr[index];
    });
    output.unshift(element);
    return output;
  });
};

/**
Bindable module.

    player = Core
      x: 5
      y: 10

    player.bind "update", ->
      updatePlayer()
    # => Uncaught TypeError: Object has no method 'bind'

    player.include(Bindable)

    player.bind "update", ->
      updatePlayer()
    # => this will call updatePlayer each time through the main loop

@name Bindable
@module
@constructor
*/
var Bindable,
  __slice = Array.prototype.slice;

Bindable = function(I, self) {
  var eventCallbacks;
  if (I == null) I = {};
  eventCallbacks = {};
  return {
    bind: function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return self.on.apply(self, args);
    },
    unbind: function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return self.off.apply(self, args);
    },
    /**
    Adds a function as an event listener.
    
        # this will call coolEventHandler after
        # yourObject.trigger "someCustomEvent" is called.
        yourObject.on "someCustomEvent", coolEventHandler
    
        #or
        yourObject.on "anotherCustomEvent", ->
          doSomething()
    
    @name on
    @methodOf Bindable#
    @param {String} event The event to listen to.
    @param {Function} callback The function to be called when the specified event
    is triggered.
    */
    on: function(namespacedEvent, callback) {
      var event, namespace, _ref;
      _ref = namespacedEvent.split("."), event = _ref[0], namespace = _ref[1];
      if (namespace) {
        callback.__PIXIE || (callback.__PIXIE = {});
        callback.__PIXIE[namespace] = true;
      }
      eventCallbacks[event] || (eventCallbacks[event] = []);
      eventCallbacks[event].push(callback);
      return this;
    },
    /**
    Removes a specific event listener, or all event listeners if
    no specific listener is given.
    
        #  removes the handler coolEventHandler from the event
        # "someCustomEvent" while leaving the other events intact.
        yourObject.off "someCustomEvent", coolEventHandler
    
        # removes all handlers attached to "anotherCustomEvent"
        yourObject.off "anotherCustomEvent"
    
    @name off
    @methodOf Bindable#
    @param {String} event The event to remove the listener from.
    @param {Function} [callback] The listener to remove.
    */
    off: function(namespacedEvent, callback) {
      var callbacks, event, key, namespace, _ref;
      _ref = namespacedEvent.split("."), event = _ref[0], namespace = _ref[1];
      if (event) {
        eventCallbacks[event] || (eventCallbacks[event] = []);
        if (namespace) {
          eventCallbacks[event] = eventCallbacks.select(function(callback) {
            var _ref2;
            return !(((_ref2 = callback.__PIXIE) != null ? _ref2[namespace] : void 0) != null);
          });
        } else {
          if (callback) {
            eventCallbacks[event].remove(callback);
          } else {
            eventCallbacks[event] = [];
          }
        }
      } else if (namespace) {
        for (key in eventCallbacks) {
          callbacks = eventCallbacks[key];
          eventCallbacks[key] = callbacks.select(function(callback) {
            var _ref2;
            return !(((_ref2 = callback.__PIXIE) != null ? _ref2[namespace] : void 0) != null);
          });
        }
      }
      return this;
    },
    /**
    Calls all listeners attached to the specified event.
    
        # calls each event handler bound to "someCustomEvent"
        yourObject.trigger "someCustomEvent"
    
    @name trigger
    @methodOf Bindable#
    @param {String} event The event to trigger.
    @param {Array} [parameters] Additional parameters to pass to the event listener.
    */
    trigger: function() {
      var callbacks, event, parameters;
      event = arguments[0], parameters = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      callbacks = eventCallbacks[event];
      if (callbacks && callbacks.length) {
        self = this;
        return callbacks.each(function(callback) {
          return callback.apply(self, parameters);
        });
      }
    }
  };
};

(typeof global !== "undefined" && global !== null ? global : this)["Bindable"] = Bindable;

var CommandStack;

CommandStack = function() {
  var index, stack;
  stack = [];
  index = 0;
  return {
    execute: function(command) {
      stack[index] = command;
      command.execute();
      return stack.length = index += 1;
    },
    undo: function() {
      var command;
      if (this.canUndo()) {
        index -= 1;
        command = stack[index];
        command.undo();
        return command;
      }
    },
    redo: function() {
      var command;
      if (this.canRedo()) {
        command = stack[index];
        command.execute();
        index += 1;
        return command;
      }
    },
    current: function() {
      return stack[index - 1];
    },
    canUndo: function() {
      return index > 0;
    },
    canRedo: function() {
      return stack[index] != null;
    }
  };
};

(typeof global !== "undefined" && global !== null ? global : this)["CommandStack"] = CommandStack;

/**
The Core class is used to add extended functionality to objects without
extending the object class directly. Inherit from Core to gain its utility
methods.

@name Core
@constructor

@param {Object} I Instance variables
*/
var __slice = Array.prototype.slice;

(function() {
  var root;
  root = typeof global !== "undefined" && global !== null ? global : window;
  return root.Core = function(I) {
    var Module, moduleName, self, _i, _len, _ref;
    if (I == null) I = {};
    Object.reverseMerge(I, {
      includedModules: []
    });
    self = {
      /**
      External access to instance variables. Use of this property should be avoided
      in general, but can come in handy from time to time.
      
          I =
            r: 255
            g: 0
            b: 100
      
          myObject = Core(I)
      
          # a bad idea most of the time, but it's
          # pretty convenient to have available.
          myObject.I.r
          # => 255
      
          myObject.I.g
          # => 0
      
          myObject.I.b
          # => 100
      
      @name I
      @fieldOf Core#
      */
      I: I,
      /**
      Generates a public jQuery style getter / setter method for each
      String argument.
      
          myObject = Core
            r: 255
            g: 0
            b: 100
      
          myObject.attrAccessor "r", "g", "b"
      
          myObject.r(254)
          myObject.r()
      
          => 254
      
      @name attrAccessor
      @methodOf Core#
      */
      attrAccessor: function() {
        var attrNames;
        attrNames = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return attrNames.each(function(attrName) {
          return self[attrName] = function(newValue) {
            if (newValue != null) {
              I[attrName] = newValue;
              return self;
            } else {
              return I[attrName];
            }
          };
        });
      },
      /**
      Generates a public jQuery style getter method for each String argument.
      
          myObject = Core
            r: 255
            g: 0
            b: 100
      
          myObject.attrReader "r", "g", "b"
      
          myObject.r()
          => 255
      
          myObject.g()
          => 0
      
          myObject.b()
          => 100
      
      @name attrReader
      @methodOf Core#
      */
      attrReader: function() {
        var attrNames;
        attrNames = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return attrNames.each(function(attrName) {
          return self[attrName] = function() {
            return I[attrName];
          };
        });
      },
      /**
      Extends this object with methods from the passed in object. A shortcut for Object.extend(self, methods)
      
          I =
            x: 30
            y: 40
            maxSpeed: 5
      
          # we are using extend to give player
          # additional methods that Core doesn't have
          player = Core(I).extend
            increaseSpeed: ->
              I.maxSpeed += 1
      
          player.I.maxSpeed
          => 5
      
          player.increaseSpeed()
      
          player.I.maxSpeed
          => 6
      
      @name extend
      @methodOf Core#
      @see Object.extend
      @returns self
      */
      extend: function(options) {
        Object.extend(self, options);
        return self;
      },
      /**
      Includes a module in this object.
      
          myObject = Core()
          myObject.include(Bindable)
      
          # now you can bind handlers to functions
          myObject.bind "someEvent", ->
            alert("wow. that was easy.")
      
      @name include
      @methodOf Core#
      @param {String} Module the module to include. A module is a constructor that takes two parameters, I and self, and returns an object containing the public methods to extend the including object with.
      */
      include: function() {
        var Module, key, moduleName, modules, value, _i, _len;
        modules = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        for (_i = 0, _len = modules.length; _i < _len; _i++) {
          Module = modules[_i];
          if (typeof Module.isString === "function" ? Module.isString() : void 0) {
            moduleName = Module;
            Module = Module.constantize();
          } else if (moduleName = Module._name) {} else {
            for (key in root) {
              value = root[key];
              if (value === Module) Module._name = moduleName = key;
            }
          }
          if (moduleName) {
            if (!I.includedModules.include(moduleName)) {
              I.includedModules.push(moduleName);
              self.extend(Module(I, self));
            }
          } else {
            warn("Unable to discover name for module: ", Module, "\nSerialization issues may occur.");
            self.extend(Module(I, self));
          }
        }
        return self;
      },
      send: function() {
        var args, name;
        name = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        return self[name].apply(self, args);
      }
    };
    self.include("Bindable");
    _ref = I.includedModules;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      moduleName = _ref[_i];
      Module = moduleName.constantize();
      self.extend(Module(I, self));
    }
    return self;
  };
})();




var __slice = Array.prototype.slice;

Function.prototype.once = function() {
  var func, memo, ran;
  func = this;
  ran = false;
  memo = void 0;
  return function() {
    if (ran) return memo;
    ran = true;
    return memo = func.apply(this, arguments);
  };
};

/**
Calling a debounced function will postpone its execution until after
wait milliseconds have elapsed since the last time the function was
invoked. Useful for implementing behavior that should only happen after
the input has stopped arriving. For example: rendering a preview of a
Markdown comment, recalculating a layout after the window has stopped
being resized...

    lazyLayout = calculateLayout.debounce(300)
    $(window).resize(lazyLayout)

@name debounce
@methodOf Function#
@returns {Function} The debounced version of this function.
*/

Function.prototype.debounce = function(wait) {
  var func, timeout;
  timeout = null;
  func = this;
  return function() {
    var args, context, later;
    context = this;
    args = arguments;
    later = function() {
      timeout = null;
      return func.apply(context, args);
    };
    clearTimeout(timeout);
    return timeout = setTimeout(later, wait);
  };
};

Function.prototype.returning = function(x) {
  var func;
  func = this;
  return function() {
    func.apply(this, arguments);
    return x;
  };
};

Function.prototype.delay = function() {
  var args, func, wait;
  wait = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
  func = this;
  return setTimeout(function() {
    return func.apply(null, args);
  }, wait);
};

Function.prototype.defer = function() {
  var args;
  args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
  return this.delay.apply(this, [1].concat(args));
};

Object.extend(Function, {
  identity: function(x) {
    return x;
  },
  noop: function() {}
});

/**
@name Logging
@namespace

Gives you some convenience methods for outputting data while developing.

      log "Testing123"
      info "Hey, this is happening"
      warn "Be careful, this might be a problem"
      error "Kaboom!"
*/
var __slice = Array.prototype.slice;

["log", "info", "warn", "error"].each(function(name) {
  if (typeof console !== "undefined") {
    return (typeof global !== "undefined" && global !== null ? global : this)[name] = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (console[name]) return console[name].apply(console, args);
    };
  } else {
    return (typeof global !== "undefined" && global !== null ? global : this)[name] = function() {};
  }
});

/**
* Matrix.js v1.3.0pre
*
* Copyright (c) 2010 STRd6
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
* Loosely based on flash:
* http://www.adobe.com/livedocs/flash/9.0/ActionScriptLangRefV3/flash/geom/Matrix.html
*/
(function() {
  /**
  <pre>
     _        _
    | a  c tx  |
    | b  d ty  |
    |_0  0  1 _|
  </pre>
  Creates a matrix for 2d affine transformations.
  
  concat, inverse, rotate, scale and translate return new matrices with the
  transformations applied. The matrix is not modified in place.
  
  Returns the identity matrix when called with no arguments.
  
  @name Matrix
  @param {Number} [a]
  @param {Number} [b]
  @param {Number} [c]
  @param {Number} [d]
  @param {Number} [tx]
  @param {Number} [ty]
  @constructor
  */
  var Matrix;
  Matrix = function(a, b, c, d, tx, ty) {
    var _ref;
    if (Object.isObject(a)) {
      _ref = a, a = _ref.a, b = _ref.b, c = _ref.c, d = _ref.d, tx = _ref.tx, ty = _ref.ty;
    }
    return {
      __proto__: Matrix.prototype,
      /**
      @name a
      @fieldOf Matrix#
      */
      a: a != null ? a : 1,
      /**
      @name b
      @fieldOf Matrix#
      */
      b: b || 0,
      /**
      @name c
      @fieldOf Matrix#
      */
      c: c || 0,
      /**
      @name d
      @fieldOf Matrix#
      */
      d: d != null ? d : 1,
      /**
      @name tx
      @fieldOf Matrix#
      */
      tx: tx || 0,
      /**
      @name ty
      @fieldOf Matrix#
      */
      ty: ty || 0
    };
  };
  Matrix.prototype = {
    /**
    Returns the result of this matrix multiplied by another matrix
    combining the geometric effects of the two. In mathematical terms,
    concatenating two matrixes is the same as combining them using matrix multiplication.
    If this matrix is A and the matrix passed in is B, the resulting matrix is A x B
    http://mathworld.wolfram.com/MatrixMultiplication.html
    @name concat
    @methodOf Matrix#
    @param {Matrix} matrix The matrix to multiply this matrix by.
    @returns {Matrix} The result of the matrix multiplication, a new matrix.
    */
    concat: function(matrix) {
      return Matrix(this.a * matrix.a + this.c * matrix.b, this.b * matrix.a + this.d * matrix.b, this.a * matrix.c + this.c * matrix.d, this.b * matrix.c + this.d * matrix.d, this.a * matrix.tx + this.c * matrix.ty + this.tx, this.b * matrix.tx + this.d * matrix.ty + this.ty);
    },
    /**
    Copy this matrix.
    @name copy
    @methodOf Matrix#
    @returns {Matrix} A copy of this matrix.
    */
    copy: function() {
      return Matrix(this.a, this.b, this.c, this.d, this.tx, this.ty);
    },
    /**
    Given a point in the pretransform coordinate space, returns the coordinates of
    that point after the transformation occurs. Unlike the standard transformation
    applied using the transformPoint() method, the deltaTransformPoint() method
    does not consider the translation parameters tx and ty.
    @name deltaTransformPoint
    @methodOf Matrix#
    @see #transformPoint
    @return {Point} A new point transformed by this matrix ignoring tx and ty.
    */
    deltaTransformPoint: function(point) {
      return Point(this.a * point.x + this.c * point.y, this.b * point.x + this.d * point.y);
    },
    /**
    Returns the inverse of the matrix.
    http://mathworld.wolfram.com/MatrixInverse.html
    @name inverse
    @methodOf Matrix#
    @returns {Matrix} A new matrix that is the inverse of this matrix.
    */
    inverse: function() {
      var determinant;
      determinant = this.a * this.d - this.b * this.c;
      return Matrix(this.d / determinant, -this.b / determinant, -this.c / determinant, this.a / determinant, (this.c * this.ty - this.d * this.tx) / determinant, (this.b * this.tx - this.a * this.ty) / determinant);
    },
    /**
    Returns a new matrix that corresponds this matrix multiplied by a
    a rotation matrix.
    @name rotate
    @methodOf Matrix#
    @see Matrix.rotation
    @param {Number} theta Amount to rotate in radians.
    @param {Point} [aboutPoint] The point about which this rotation occurs. Defaults to (0,0).
    @returns {Matrix} A new matrix, rotated by the specified amount.
    */
    rotate: function(theta, aboutPoint) {
      return this.concat(Matrix.rotation(theta, aboutPoint));
    },
    /**
    Returns a new matrix that corresponds this matrix multiplied by a
    a scaling matrix.
    @name scale
    @methodOf Matrix#
    @see Matrix.scale
    @param {Number} sx
    @param {Number} [sy]
    @param {Point} [aboutPoint] The point that remains fixed during the scaling
    @returns {Matrix} A new Matrix. The original multiplied by a scaling matrix.
    */
    scale: function(sx, sy, aboutPoint) {
      return this.concat(Matrix.scale(sx, sy, aboutPoint));
    },
    /**
    Returns a new matrix that corresponds this matrix multiplied by a
    a skewing matrix.
    
    @name skew
    @methodOf Matrix#
    @see Matrix.skew
    @param {Number} skewX The angle of skew in the x dimension.
    @param {Number} skewY The angle of skew in the y dimension.
    */
    skew: function(skewX, skewY) {
      return this.concat(Matrix.skew(skewX, skewY));
    },
    /**
    Returns a string representation of this matrix.
    
    @name toString
    @methodOf Matrix#
    @returns {String} A string reperesentation of this matrix.
    */
    toString: function() {
      return "Matrix(" + this.a + ", " + this.b + ", " + this.c + ", " + this.d + ", " + this.tx + ", " + this.ty + ")";
    },
    /**
    Returns the result of applying the geometric transformation represented by the
    Matrix object to the specified point.
    @name transformPoint
    @methodOf Matrix#
    @see #deltaTransformPoint
    @returns {Point} A new point with the transformation applied.
    */
    transformPoint: function(point) {
      return Point(this.a * point.x + this.c * point.y + this.tx, this.b * point.x + this.d * point.y + this.ty);
    },
    /**
    Translates the matrix along the x and y axes, as specified by the tx and ty parameters.
    @name translate
    @methodOf Matrix#
    @see Matrix.translation
    @param {Number} tx The translation along the x axis.
    @param {Number} ty The translation along the y axis.
    @returns {Matrix} A new matrix with the translation applied.
    */
    translate: function(tx, ty) {
      return this.concat(Matrix.translation(tx, ty));
    }
  };
  /**
  Creates a matrix transformation that corresponds to the given rotation,
  around (0,0) or the specified point.
  @see Matrix#rotate
  @param {Number} theta Rotation in radians.
  @param {Point} [aboutPoint] The point about which this rotation occurs. Defaults to (0,0).
  @returns {Matrix} A new matrix rotated by the given amount.
  */
  Matrix.rotate = Matrix.rotation = function(theta, aboutPoint) {
    var rotationMatrix;
    rotationMatrix = Matrix(Math.cos(theta), Math.sin(theta), -Math.sin(theta), Math.cos(theta));
    if (aboutPoint != null) {
      rotationMatrix = Matrix.translation(aboutPoint.x, aboutPoint.y).concat(rotationMatrix).concat(Matrix.translation(-aboutPoint.x, -aboutPoint.y));
    }
    return rotationMatrix;
  };
  /**
  Returns a matrix that corresponds to scaling by factors of sx, sy along
  the x and y axis respectively.
  If only one parameter is given the matrix is scaled uniformly along both axis.
  If the optional aboutPoint parameter is given the scaling takes place
  about the given point.
  @see Matrix#scale
  @param {Number} sx The amount to scale by along the x axis or uniformly if no sy is given.
  @param {Number} [sy] The amount to scale by along the y axis.
  @param {Point} [aboutPoint] The point about which the scaling occurs. Defaults to (0,0).
  @returns {Matrix} A matrix transformation representing scaling by sx and sy.
  */
  Matrix.scale = function(sx, sy, aboutPoint) {
    var scaleMatrix;
    sy = sy || sx;
    scaleMatrix = Matrix(sx, 0, 0, sy);
    if (aboutPoint) {
      scaleMatrix = Matrix.translation(aboutPoint.x, aboutPoint.y).concat(scaleMatrix).concat(Matrix.translation(-aboutPoint.x, -aboutPoint.y));
    }
    return scaleMatrix;
  };
  /**
  Returns a matrix that corresponds to a skew of skewX, skewY.
  
  @see Matrix#skew
  @param {Number} skewX The angle of skew in the x dimension.
  @param {Number} skewY The angle of skew in the y dimension.
  @return {Matrix} A matrix transformation representing a skew by skewX and skewY.
  */
  Matrix.skew = function(skewX, skewY) {
    return Matrix(0, Math.tan(skewY), Math.tan(skewX), 0);
  };
  /**
  Returns a matrix that corresponds to a translation of tx, ty.
  @see Matrix#translate
  @param {Number} tx The amount to translate in the x direction.
  @param {Number} ty The amount to translate in the y direction.
  @return {Matrix} A matrix transformation representing a translation by tx and ty.
  */
  Matrix.translate = Matrix.translation = function(tx, ty) {
    return Matrix(1, 0, 0, 1, tx, ty);
  };
  /**
  A constant representing the identity matrix.
  @name IDENTITY
  @fieldOf Matrix
  */
  Matrix.IDENTITY = Matrix();
  /**
  A constant representing the horizontal flip transformation matrix.
  @name HORIZONTAL_FLIP
  @fieldOf Matrix
  */
  Matrix.HORIZONTAL_FLIP = Matrix(-1, 0, 0, 1);
  /**
  A constant representing the vertical flip transformation matrix.
  @name VERTICAL_FLIP
  @fieldOf Matrix
  */
  Matrix.VERTICAL_FLIP = Matrix(1, 0, 0, -1);
  if (Object.freeze) {
    Object.freeze(Matrix.IDENTITY);
    Object.freeze(Matrix.HORIZONTAL_FLIP);
    Object.freeze(Matrix.VERTICAL_FLIP);
  }
  return this["Matrix"] = Matrix;
})();

/**
Returns the absolute value of this number.

    (-4).abs()
    # => 4

@name abs
@methodOf Number#
@returns {Number} The absolute value of the number.
*/
/**
Returns the mathematical ceiling of this number.

    4.9.ceil()
    # => 5

    4.2.ceil()
    # => 5

    (-1.2).ceil()
    # => -1

@name ceil
@methodOf Number#
@returns {Number} The number truncated to the nearest integer of greater than or equal value.
*/
/**
Returns the mathematical floor of this number.

    4.9.floor()
    # => 4

    4.2.floor()
    # => 4

    (-1.2).floor()
    # => -2

@name floor
@methodOf Number#
@returns {Number} The number truncated to the nearest integer of less than or equal value.
*/
/**
Returns this number rounded to the nearest integer.

    4.5.round()
    # => 5

    4.4.round()
    # => 4

@name round
@methodOf Number#
@returns {Number} The number rounded to the nearest integer.
*/
["abs", "ceil", "floor", "round"].each(function(method) {
  return Number.prototype[method] = function() {
    return Math[method](this);
  };
});

/**
Get a bunch of points equally spaced around the unit circle.

    4.circularPoints (p) ->

    # p gets Point(1, 0), Point(0, 1), Point(-1, 0), Point(0, -1)

@name circularPoint
@methodOf Number#
*/

Number.prototype.circularPoints = function(block) {
  var n;
  n = this;
  return n.times(function(i) {
    return block(Point.fromAngle((i / n).turns), i);
  });
};

/**
Returns a number whose value is limited to the given range.

    # limit the output of this computation to between 0 and 255
    (2 * 255).clamp(0, 255)
    # => 255

@name clamp
@methodOf Number#
@param {Number} min The lower boundary of the output range
@param {Number} max The upper boundary of the output range
@returns {Number} A number in the range [min, max]
*/

Number.prototype.clamp = function(min, max) {
  if ((min != null) && (max != null)) {
    return Math.min(Math.max(this, min), max);
  } else if (min != null) {
    return Math.max(this, min);
  } else if (max != null) {
    return Math.min(this, max);
  } else {
    return this;
  }
};

/**
A mod method useful for array wrapping. The range of the function is
constrained to remain in bounds of array indices.

    (-1).mod(5)
    # => 4

@name mod
@methodOf Number#
@param {Number} base
@returns {Number} An integer between 0 and (base - 1) if base is positive.
*/

Number.prototype.mod = function(base) {
  var result;
  result = this % base;
  if (result < 0 && base > 0) result += base;
  return result;
};

/**
Get the sign of this number as an integer (1, -1, or 0).

    (-5).sign()
    # => -1

    0.sign()
    # => 0

    5.sign()
    # => 1

@name sign
@methodOf Number#
@returns {Number} The sign of this number, 0 if the number is 0.
*/

Number.prototype.sign = function() {
  if (this > 0) {
    return 1;
  } else if (this < 0) {
    return -1;
  } else {
    return 0;
  }
};

/**
Returns true if this number is even (evenly divisible by 2).

    2.even()
    # => true

    3.even()
    # => false

    0.even()
    # => true

@name even
@methodOf Number#
@returns {Boolean} true if this number is an even integer, false otherwise.
*/

Number.prototype.even = function() {
  return this.mod(2) === 0;
};

/**
Returns true if this number is odd (has remainder of 1 when divided by 2).

    2.odd()
    # => false

    3.odd()
    # => true

    0.odd()
    # => false

@name odd
@methodOf Number#
@returns {Boolean} true if this number is an odd integer, false otherwise.
*/

Number.prototype.odd = function() {
  return this.mod(2) === 1;
};

/**
Calls iterator the specified number of times, passing in the number of the
current iteration as a parameter: 0 on first call, 1 on the second call, etc.

    output = []

    5.times (n) ->
      output.push(n)

    output
    # => [0, 1, 2, 3, 4]

@name times
@methodOf Number#
@param {Function} iterator The iterator takes a single parameter, the number of the current iteration.
@param {Object} [context] The optional context parameter specifies an object to treat as <code>this</code> in the iterator block.
@returns {Number} The number of times the iterator was called.
*/

Number.prototype.times = function(iterator, context) {
  var i;
  i = -1;
  while (++i < this) {
    iterator.call(context, i);
  }
  return i;
};

/**
Returns the the nearest grid resolution less than or equal to the number.

    7.snap(8)
    # => 0

    4.snap(8)
    # => 0

    12.snap(8)
    # => 8

@name snap
@methodOf Number#
@param {Number} resolution The grid resolution to snap to.
@returns {Number} The nearest multiple of resolution lower than the number.
*/

Number.prototype.snap = function(resolution) {
  var n;
  n = this / resolution;
  1 / 1;
  return n.floor() * resolution;
};

/**
In number theory, integer factorization or prime factorization is the
breaking down of a composite number into smaller non-trivial divisors,
which when multiplied together equal the original integer.

Floors the number for purposes of factorization.

    60.primeFactors()
    # => [2, 2, 3, 5]

    37.primeFactors()
    # => [37]

@name primeFactors
@methodOf Number#
@returns {Array} An array containing the factorization of this number.
*/

Number.prototype.primeFactors = function() {
  var factors, i, iSquared, n;
  factors = [];
  n = this.floor();
  if (n === 0) return;
  if (n < 0) {
    factors.push(-1);
    n /= -1;
  }
  i = 2;
  iSquared = i * i;
  while (iSquared < n) {
    while ((n % i) === 0) {
      factors.push(i);
      n /= i;
    }
    i += 1;
    iSquared = i * i;
  }
  if (n !== 1) factors.push(n);
  return factors;
};

/**
Returns the two character hexidecimal
representation of numbers 0 through 255.

    255.toColorPart()
    # => "ff"

    0.toColorPart()
    # => "00"

    200.toColorPart()
    # => "c8"

@name toColorPart
@methodOf Number#
@returns {String} Hexidecimal representation of the number
*/

Number.prototype.toColorPart = function() {
  var s;
  s = parseInt(this.clamp(0, 255), 10).toString(16);
  if (s.length === 1) s = '0' + s;
  return s;
};

/**
Returns a number that is maxDelta closer to target.

    255.approach(0, 5)
    # => 250

    5.approach(0, 10)
    # => 0

@name approach
@methodOf Number#
@returns {Number} A number maxDelta toward target
*/

Number.prototype.approach = function(target, maxDelta) {
  return (target - this).clamp(-maxDelta, maxDelta) + this;
};

/**
Returns a number that is closer to the target by the ratio.

    255.approachByRatio(0, 0.1)
    # => 229.5

@name approachByRatio
@methodOf Number#
@returns {Number} A number toward target by the ratio
*/

Number.prototype.approachByRatio = function(target, ratio) {
  return this.approach(target, this * ratio);
};

/**
Returns a number that is closer to the target angle by the delta.

    Math.PI.approachRotation(0, Math.PI/4)
    # => 2.356194490192345 # this is (3/4) * Math.PI, which is (1/4) * Math.PI closer to 0 from Math.PI

@name approachRotation
@methodOf Number#
@returns {Number} A number toward the target angle by maxDelta
*/

Number.prototype.approachRotation = function(target, maxDelta) {
  while (target > this + Math.PI) {
    target -= Math.TAU;
  }
  while (target < this - Math.PI) {
    target += Math.TAU;
  }
  return (target - this).clamp(-maxDelta, maxDelta) + this;
};

/**
Constrains a rotation to between -PI and PI.

    (9/4 * Math.PI).constrainRotation()
    # => 0.7853981633974483 # this is (1/4) * Math.PI

@name constrainRotation
@methodOf Number#
@returns {Number} This number constrained between -PI and PI.
*/

Number.prototype.constrainRotation = function() {
  var target;
  target = this;
  while (target > Math.PI) {
    target -= Math.TAU;
  }
  while (target < -Math.PI) {
    target += Math.TAU;
  }
  return target;
};

Number.prototype.truncate = function() {
  if (this > 0) {
    return this.floor();
  } else if (this < 0) {
    return this.ceil();
  } else {
    return this;
  }
};

/**
The mathematical d operator. Useful for simulating dice rolls.

@name d
@methodOf Number#
@returns {Number} The sum of rolling <code>this</code> many <code>sides</code>-sided dice
*/

Number.prototype.d = function(sides) {
  var sum;
  sum = 0;
  this.times(function() {
    return sum += rand(sides) + 1;
  });
  return sum;
};

/**
Utility method to convert a number to a duration of seconds.

    3.seconds
    # => 3000

    setTimout doSometing, 3.seconds

@name seconds
@propertyOf Number#
@returns {Number} This number as a duration of seconds
*/

if (!5..seconds) {
  Object.defineProperty(Number.prototype, 'seconds', {
    get: function() {
      return this * 1000;
    }
  });
}

if (!1..second) {
  Object.defineProperty(Number.prototype, 'second', {
    get: function() {
      return this * 1000;
    }
  });
}

/**
Utility method to convert a number to an amount of rotations.

    0.5.rotations
    # => 3.141592653589793

    I.rotation = 0.25.rotations

@name rotations
@propertyOf Number#
@returns {Number} This number as an amount of rotations
*/

if (!5..rotations) {
  Object.defineProperty(Number.prototype, 'rotations', {
    get: function() {
      return this * Math.TAU;
    }
  });
}

if (!1..rotation) {
  Object.defineProperty(Number.prototype, 'rotation', {
    get: function() {
      return this * Math.TAU;
    }
  });
}

/**
Utility method to convert a number to an amount of rotations.

    0.5.turns
    # => 3.141592653589793

    I.rotation = 0.25.turns

    1.turn # => Math.TAU (aka 2 * Math.PI)

@name turns
@propertyOf Number#
@returns {Number} This number as an amount of rotation.
1 turn is one complete rotation.
*/

if (!5..turns) {
  Object.defineProperty(Number.prototype, 'turns', {
    get: function() {
      return this * Math.TAU;
    }
  });
}

if (!1..turn) {
  Object.defineProperty(Number.prototype, 'turn', {
    get: function() {
      return this * Math.TAU;
    }
  });
}

/**
Utility method to convert a number to an amount of degrees.

    180.degrees
    # => 3.141592653589793

    I.rotation = 90.degrees

@name degrees
@propertyOf Number#
@returns {Number} This number as an amount of degrees
*/

if (!2..degrees) {
  Object.defineProperty(Number.prototype, 'degrees', {
    get: function() {
      return this * Math.TAU / 360;
    }
  });
}

if (!1..degree) {
  Object.defineProperty(Number.prototype, 'degree', {
    get: function() {
      return this * Math.TAU / 360;
    }
  });
}

/**
The mathematical circle constant of 1 turn.

@name TAU
@fieldOf Math
*/

Math.TAU = 2 * Math.PI;

var __slice = Array.prototype.slice;

(function() {
  /**
  Create a new point with given x and y coordinates. If no arguments are given
  defaults to (0, 0).
  
      point = Point()
  
      p.x
      # => 0
  
      p.y
      # => 0
  
      point = Point(-2, 5)
  
      p.x
      # => -2
  
      p.y
      # => 5
  
  @name Point
  @param {Number} [x]
  @param {Number} [y]
  @constructor
  */
  var Point;
  Point = function(x, y) {
    var _ref;
    if (Object.isObject(x)) _ref = x, x = _ref.x, y = _ref.y;
    return {
      __proto__: Point.prototype,
      /**
      The x coordinate of this point.
      @name x
      @fieldOf Point#
      */
      x: x || 0,
      /**
      The y coordinate of this point.
      @name y
      @fieldOf Point#
      */
      y: y || 0
    };
  };
  Point.prototype = {
    /**
    Constrain the magnitude of a vector.
    
    @name clamp
    @methodOf Point#
    @param {Number} n Maximum value for magnitude.
    @returns {Point} A new point whose magnitude has been clamped to the given value.
    */
    clamp: function(n) {
      return this.copy().clamp$(n);
    },
    clamp$: function(n) {
      if (this.magnitude() > n) {
        return this.norm$(n);
      } else {
        return this;
      }
    },
    /**
    Creates a copy of this point.
    
    @name copy
    @methodOf Point#
    @returns {Point} A new point with the same x and y value as this point.
    
        point = Point(1, 1)
        pointCopy = point.copy()
    
        point.equal(pointCopy)
        # => true
    
        point == pointCopy
        # => false
    */
    copy: function() {
      return Point(this.x, this.y);
    },
    /**
    Adds a point to this one and returns the new point. You may
    also use a two argument call like <code>point.add(x, y)</code>
    to add x and y values without a second point object.
    
        point = Point(2, 3).add(Point(3, 4))
    
        point.x
        # => 5
    
        point.y
        # => 7
    
        anotherPoint = Point(2, 3).add(3, 4)
    
        anotherPoint.x
        # => 5
    
        anotherPoint.y
        # => 7
    
    @name add
    @methodOf Point#
    @param {Point} other The point to add this point to.
    @returns {Point} A new point, the sum of both.
    */
    add: function(first, second) {
      return this.copy().add$(first, second);
    },
    /**
    Adds a point to this one, returning a modified point. You may
    also use a two argument call like <code>point.add(x, y)</code>
    to add x and y values without a second point object.
    
        point = Point(2, 3)
    
        point.x
        # => 2
    
        point.y
        # => 3
    
        point.add$(Point(3, 4))
    
        point.x
        # => 5
    
        point.y
        # => 7
    
        anotherPoint = Point(2, 3)
        anotherPoint.add$(3, 4)
    
        anotherPoint.x
        # => 5
    
        anotherPoint.y
        # => 7
    
    @name add$
    @methodOf Point#
    @param {Point} other The point to add this point to.
    @returns {Point} The sum of both points.
    */
    add$: function(first, second) {
      if (second != null) {
        this.x += first;
        this.y += second;
      } else {
        this.x += first.x;
        this.y += first.y;
      }
      return this;
    },
    /**
    Subtracts a point to this one and returns the new point.
    
        point = Point(1, 2).subtract(Point(2, 0))
    
        point.x
        # => -1
    
        point.y
        # => 2
    
        anotherPoint = Point(1, 2).subtract(2, 0)
    
        anotherPoint.x
        # => -1
    
        anotherPoint.y
        # => 2
    
    @name subtract
    @methodOf Point#
    @param {Point} other The point to subtract from this point.
    @returns {Point} A new point, this - other.
    */
    subtract: function(first, second) {
      return this.copy().subtract$(first, second);
    },
    /**
    Subtracts a point to this one and returns the new point.
    
        point = Point(1, 2)
    
        point.x
        # => 1
    
        point.y
        # => 2
    
        point.subtract$(Point(2, 0))
    
        point.x
        # => -1
    
        point.y
        # => 2
    
        anotherPoint = Point(1, 2)
        anotherPoint.subtract$(2, 0)
    
        anotherPoint.x
        # => -1
    
        anotherPoint.y
        # => 2
    
    @name subtract$
    @methodOf Point#
    @param {Point} other The point to subtract from this point.
    @returns {Point} The difference of the two points.
    */
    subtract$: function(first, second) {
      if (second != null) {
        this.x -= first;
        this.y -= second;
      } else {
        this.x -= first.x;
        this.y -= first.y;
      }
      return this;
    },
    /**
    Scale this Point (Vector) by a constant amount.
    
        point = Point(5, 6).scale(2)
    
        point.x
        # => 10
    
        point.y
        # => 12
    
    @name scale
    @methodOf Point#
    @param {Number} scalar The amount to scale this point by.
    @returns {Point} A new point, this * scalar.
    */
    scale: function(scalar) {
      return this.copy().scale$(scalar);
    },
    /**
    Scale this Point (Vector) by a constant amount. Modifies the point in place.
    
        point = Point(5, 6)
    
        point.x
        # => 5
    
        point.y
        # => 6
    
        point.scale$(2)
    
        point.x
        # => 10
    
        point.y
        # => 12
    
    @name scale$
    @methodOf Point#
    @param {Number} scalar The amount to scale this point by.
    @returns {Point} this * scalar.
    */
    scale$: function(scalar) {
      this.x *= scalar;
      this.y *= scalar;
      return this;
    },
    /**
    The norm of a vector is the unit vector pointing in the same direction. This method
    treats the point as though it is a vector from the origin to (x, y).
    
        point = Point(2, 3).norm()
    
        point.x
        # => 0.5547001962252291
    
        point.y
        # => 0.8320502943378437
    
        anotherPoint = Point(2, 3).norm(2)
    
        anotherPoint.x
        # => 1.1094003924504583
    
        anotherPoint.y
        # => 1.6641005886756874
    
    @name norm
    @methodOf Point#
    @returns {Point} The unit vector pointing in the same direction as this vector.
    */
    norm: function(length) {
      if (length == null) length = 1.0;
      return this.copy().norm$(length);
    },
    /**
    The norm of a vector is the unit vector pointing in the same direction. This method
    treats the point as though it is a vector from the origin to (x, y). Modifies the point in place.
    
        point = Point(2, 3).norm$()
    
        point.x
        # => 0.5547001962252291
    
        point.y
        # => 0.8320502943378437
    
        anotherPoint = Point(2, 3).norm$(2)
    
        anotherPoint.x
        # => 1.1094003924504583
    
        anotherPoint.y
        # => 1.6641005886756874
    
    @name norm$
    @methodOf Point#
    @returns {Point} The unit vector pointing in the same direction as this vector.
    */
    norm$: function(length) {
      var m;
      if (length == null) length = 1.0;
      if (m = this.length()) {
        return this.scale$(length / m);
      } else {
        return this;
      }
    },
    /**
    Floor the x and y values, returning a new point.
    
        point = Point(3.4, 5.8).floor()
    
        point.x
        # => 3
    
        point.y
        # => 5
    
    @name floor
    @methodOf Point#
    @returns {Point} A new point, with x and y values each floored to the largest previous integer.
    */
    /**
    Determine whether this point is equal to another point.
    
        pointA = Point(2, 3)
        pointB = Point(2, 3)
        pointC = Point(4, 5)
    
        pointA.equal(pointB)
        # => true
    
        pointA.equal(pointC)
        # => false
    
    @name equal
    @methodOf Point#
    @param {Point} other The point to check for equality.
    @returns {Boolean} true if the other point has the same x, y coordinates, false otherwise.
    */
    equal: function(other) {
      return this.x === other.x && this.y === other.y;
    },
    /**
    Computed the length of this point as though it were a vector from (0,0) to (x,y).
    
        point = Point(5, 7)
    
        point.length()
        # => 8.602325267042627
    
    @name length
    @methodOf Point#
    @returns {Number} The length of the vector from the origin to this point.
    */
    length: function() {
      return Math.sqrt(this.dot(this));
    },
    /**
    Calculate the magnitude of this Point (Vector).
    
        point = Point(5, 7)
    
        point.magnitude()
        # => 8.602325267042627
    
    @name magnitude
    @methodOf Point#
    @returns {Number} The magnitude of this point as if it were a vector from (0, 0) -> (x, y).
    */
    magnitude: function() {
      return this.length();
    },
    /**
    Returns the direction in radians of this point from the origin.
    
        point = Point(0, 1)
    
        point.direction()
        # => 1.5707963267948966 # Math.PI / 2
    
    @name direction
    @methodOf Point#
    @returns {Number} The direction in radians of this point from the origin
    */
    direction: function() {
      return Math.atan2(this.y, this.x);
    },
    /**
    Calculate the dot product of this point and another point (Vector).
    @name dot
    @methodOf Point#
    @param {Point} other The point to dot with this point.
    @returns {Number} The dot product of this point dot other as a scalar value.
    */
    dot: function(other) {
      return this.x * other.x + this.y * other.y;
    },
    /**
    Calculate the cross product of this point and another point (Vector).
    Usually cross products are thought of as only applying to three dimensional vectors,
    but z can be treated as zero. The result of this method is interpreted as the magnitude
    of the vector result of the cross product between [x1, y1, 0] x [x2, y2, 0]
    perpendicular to the xy plane.
    
    @name cross
    @methodOf Point#
    @param {Point} other The point to cross with this point.
    @returns {Number} The cross product of this point with the other point as scalar value.
    */
    cross: function(other) {
      return this.x * other.y - other.x * this.y;
    },
    /**
    Compute the Euclidean distance between this point and another point.
    
        pointA = Point(2, 3)
        pointB = Point(9, 2)
    
        pointA.distance(pointB)
        # => 7.0710678118654755 # Math.sqrt(50)
    
    @name distance
    @methodOf Point#
    @param {Point} other The point to compute the distance to.
    @returns {Number} The distance between this point and another point.
    */
    distance: function(other) {
      return Point.distance(this, other);
    },
    /**
    @name toString
    @methodOf Point#
    @returns {String} A string representation of this point.
    */
    toString: function() {
      return "Point(" + this.x + ", " + this.y + ")";
    },
    snap: function(n) {
      return Point({
        x: this.x.snap(n),
        y: this.y.snap(n)
      });
    },
    angle: function() {
      return Math.atan2(this.y, this.x);
    }
  };
  "abs\nceil\nfloor\ntruncate".split("\n").each(function(method) {
    return Point.prototype[method] = function() {
      return Point({
        x: this.x[method](),
        y: this.y[method]()
      });
    };
  });
  /**
  Compute the Euclidean distance between two points.
  
      pointA = Point(2, 3)
      pointB = Point(9, 2)
  
      Point.distance(pointA, pointB)
      # => 7.0710678118654755 # Math.sqrt(50)
  
  @name distance
  @fieldOf Point
  @param {Point} p1
  @param {Point} p2
  @returns {Number} The Euclidean distance between two points.
  */
  Point.distance = function(p1, p2) {
    return Math.sqrt(Point.distanceSquared(p1, p2));
  };
  /**
      pointA = Point(2, 3)
      pointB = Point(9, 2)
  
      Point.distanceSquared(pointA, pointB)
      # => 50
  
  @name distanceSquared
  @fieldOf Point
  @param {Point} p1
  @param {Point} p2
  @returns {Number} The square of the Euclidean distance between two points.
  */
  Point.distanceSquared = function(p1, p2) {
    return Math.pow(p2.x - p1.x, 2) + Math.pow(p2.y - p1.y, 2);
  };
  /**
  @name interpolate
  @fieldOf Point
  
  @param {Point} p1
  @param {Point} p2
  @param {Number} t
  @returns {Point} A point along the path from p1 to p2
  */
  Point.interpolate = function(p1, p2, t) {
    return p2.subtract(p1).scale(t).add(p1);
  };
  /**
  Construct a point on the unit circle for the given angle.
  
      point = Point.fromAngle(Math.PI / 2)
  
      point.x
      # => 0
  
      point.y
      # => 1
  
  @name fromAngle
  @fieldOf Point
  @param {Number} angle The angle in radians
  @returns {Point} The point on the unit circle.
  */
  Point.fromAngle = function(angle) {
    return Point(Math.cos(angle), Math.sin(angle));
  };
  /**
  If you have two dudes, one standing at point p1, and the other
  standing at point p2, then this method will return the direction
  that the dude standing at p1 will need to face to look at p2.
  
      p1 = Point(0, 0)
      p2 = Point(7, 3)
  
      Point.direction(p1, p2)
      # => 0.40489178628508343
  
  @name direction
  @fieldOf Point
  @param {Point} p1 The starting point.
  @param {Point} p2 The ending point.
  @returns {Number} The direction from p1 to p2 in radians.
  */
  Point.direction = function(p1, p2) {
    return Math.atan2(p2.y - p1.y, p2.x - p1.x);
  };
  /**
  The centroid of a set of points is their arithmetic mean.
  
  @name centroid
  @methodOf Point
  @param points... The points to find the centroid of.
  */
  Point.centroid = function() {
    var points;
    points = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return points.inject(Point(0, 0), function(sumPoint, point) {
      return sumPoint.add(point);
    }).scale(1 / points.length);
  };
  /**
  Generate a random point on the unit circle.
  
  @returns {Point} A random point on the unit circle.
  */
  Point.random = function() {
    return Point.fromAngle(Random.angle());
  };
  /**
  @name ZERO
  @fieldOf Point
  @returns {Point} The point (0, 0)
  */
  Point.ZERO = Point(0, 0);
  /**
  @name LEFT
  @fieldOf Point
  @returns {Point} The point (-1, 0)
  */
  Point.LEFT = Point(-1, 0);
  /**
  @name RIGHT
  @fieldOf Point
  @returns {Point} The point (1, 0)
  */
  Point.RIGHT = Point(1, 0);
  /**
  @name UP
  @fieldOf Point
  @returns {Point} The point (0, -1)
  */
  Point.UP = Point(0, -1);
  /**
  @name DOWN
  @fieldOf Point
  @returns {Point} The point (0, 1)
  */
  Point.DOWN = Point(0, 1);
  if (Object.freeze) {
    Object.freeze(Point.ZERO);
    Object.freeze(Point.LEFT);
    Object.freeze(Point.RIGHT);
    Object.freeze(Point.UP);
    Object.freeze(Point.DOWN);
  }
  return (typeof global !== "undefined" && global !== null ? global : this)["Point"] = Point;
})();


(function() {
  /**
  @name Random
  @namespace Some useful methods for generating random things.
  */  this["Random"] = {
    /**
    Returns a random angle, uniformly distributed, between 0 and 2pi.
    
    @name angle
    @methodOf Random
    @returns {Number} A random angle between 0 and 2pi
    */
    angle: function() {
      return rand() * Math.TAU;
    },
    /**
    Returns a random angle between the given angles.
    
    @name angleBetween
    @methodOf Random
    @returns {Number} A random angle between the angles given.
    */
    angleBetween: function(min, max) {
      return rand() * (max - min) + min;
    },
    /**
    Returns a random color.
    
    @name color
    @methodOf Random
    @returns {Color} A random color
    */
    color: function() {
      return Color.random();
    },
    /**
    Happens often.
    
    @name often
    @methodOf Random
    */
    often: function() {
      return rand(3);
    },
    /**
    Happens sometimes.
    
    @name sometimes
    @methodOf Random
    */
    sometimes: function() {
      return !rand(3);
    }
  };
  /**
  Returns random integers from [0, n) if n is given.
  Otherwise returns random float between 0 and 1.
  
  @name rand
  @methodOf window
  @param {Number} n
  @returns {Number} A random integer from 0 to n - 1 if n is given. If n is not given, a random float between 0 and 1.
  */
  this["rand"] = function(n) {
    if (n) {
      return Math.floor(n * Math.random());
    } else {
      return Math.random();
    }
  };
  /**
  Returns random float from [-n / 2, n / 2] if n is given.
  Otherwise returns random float between -0.5 and 0.5.
  
  @name signedRand
  @methodOf window
  @param {Number} n
  @returns {Number} A random float from -n / 2 to n / 2 if n is given. If n is not given, a random float between -0.5 and 0.5.
  */
  return this["signedRand"] = function(n) {
    if (n) {
      return (n * Math.random()) - (n / 2);
    } else {
      return Math.random() - 0.5;
    }
  };
})();


(function() {
  var Rectangle;
  Rectangle = function(_arg) {
    var height, width, x, y;
    x = _arg.x, y = _arg.y, width = _arg.width, height = _arg.height;
    return {
      __proto__: Rectangle.prototype,
      x: x || 0,
      y: y || 0,
      width: width || 0,
      height: height || 0
    };
  };
  Rectangle.prototype = {
    center: function() {
      return Point(this.x + this.width / 2, this.y + this.height / 2);
    },
    equal: function(other) {
      return this.x === other.x && this.y === other.y && this.width === other.width && this.height === other.height;
    }
  };
  Rectangle.prototype.__defineGetter__('left', function() {
    return this.x;
  });
  Rectangle.prototype.__defineGetter__('right', function() {
    return this.x + this.width;
  });
  Rectangle.prototype.__defineGetter__('top', function() {
    return this.y;
  });
  Rectangle.prototype.__defineGetter__('bottom', function() {
    return this.y + this.height;
  });
  return this["Rectangle"] = Rectangle;
})();

/**
Returns true if this string only contains whitespace characters.

    "".blank()
    # => true

    "hello".blank()
    # => false

    "   ".blank()
    # => true

@name blank
@methodOf String#
@returns {Boolean} Whether or not this string is blank.
*/
String.prototype.blank = function() {
  return /^\s*$/.test(this);
};

/**
Returns a new string that is a camelCase version.

    "camel_case".camelize()
    "camel-case".camelize()
    "camel case".camelize()

    # => "camelCase"

@name camelize
@methodOf String#
@returns {String} A new string. camelCase version of `this`.
*/

String.prototype.camelize = function() {
  return this.trim().replace(/(\-|_|\s)+(.)?/g, function(match, separator, chr) {
    if (chr) {
      return chr.toUpperCase();
    } else {
      return '';
    }
  });
};

/**
Returns a new string with the first letter capitalized and the rest lower cased.

    "capital".capitalize()
    "cAPITAL".capitalize()
    "cApItAl".capitalize()
    "CAPITAL".capitalize()

    # => "Capital"

@name capitalize
@methodOf String#
@returns {String} A new string. Capitalized version of `this`
*/

String.prototype.capitalize = function() {
  return this.charAt(0).toUpperCase() + this.substring(1).toLowerCase();
};

/**
Return the class or constant named in this string.


    "Constant".constantize()
    # => Constant
    # notice this isn't a string. Useful for calling methods on class with the same name as `this`.

@name constantize
@methodOf String#
@returns {Object} The class or constant named in this string.
*/

String.prototype.constantize = function() {
  var item, target, _i, _len, _ref;
  target = typeof global !== "undefined" && global !== null ? global : window;
  _ref = this.split('.');
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    item = _ref[_i];
    target = target[item];
  }
  return target;
};

/**
Get the file extension of a string.

    "README.md".extension() # => "md"
    "README".extension() # => ""

@name extension
@methodOf String#
@returns {String} File extension
*/

String.prototype.extension = function() {
  var extension, _ref;
  if (extension = (_ref = this.match(/\.([^\.]*)$/, '')) != null ? _ref.last() : void 0) {
    return extension;
  } else {
    return '';
  }
};

/**
Returns a new string that is a more human readable version.

    "player_id".humanize()
    # => "Player"

    "player_ammo".humanize()
    # => "Player ammo"

@name humanize
@methodOf String#
@returns {String} A new string. Replaces _id and _ with "" and capitalizes the word.
*/

String.prototype.humanize = function() {
  return this.replace(/_id$/, "").replace(/_/g, " ").capitalize();
};

/**
Returns true.

@name isString
@methodOf String#
@returns {Boolean} true
*/

String.prototype.isString = function() {
  return true;
};

/**
Parse this string as though it is JSON and return the object it represents. If it
is not valid JSON returns the string itself.

    # this is valid json, so an object is returned
    '{"a": 3}'.parse()
    # => {a: 3}

    # double quoting instead isn't valid JSON so a string is returned
    "{'a': 3}".parse()
    # => "{'a': 3}"


@name parse
@methodOf String#
@returns {Object} Returns an object from the JSON this string contains. If it is not valid JSON returns the string itself.
*/

String.prototype.parse = function() {
  try {
    return JSON.parse(this.toString());
  } catch (e) {
    return this.toString();
  }
};

/**
Returns true if this string starts with the given string.

@name startsWith
@methodOf String#
@param {String} str The string to check.

@returns {Boolean} True if this string starts with the given string, false otherwise.
*/

String.prototype.startsWith = function(str) {
  return this.lastIndexOf(str, 0) === 0;
};

/**
Returns a new string in Title Case.

    "title-case".titleize()
    # => "Title Case"

    "title case".titleize()
    # => "Title Case"

@name titleize
@methodOf String#
@returns {String} A new string. Title Cased.
*/

String.prototype.titleize = function() {
  return this.split(/[- ]/).map(function(word) {
    return word.capitalize();
  }).join(' ');
};

/**
Underscore a word, changing camelCased with under_scored.

    "UNDERScore".underscore()
    # => "under_score"

    "UNDER-SCORE".underscore()
    # => "under_score"

    "UnDEr-SCorE".underscore()
    # => "un_d_er_s_cor_e"

@name underscore
@methodOf String#
@returns {String} A new string. Separated by _.
*/

String.prototype.underscore = function() {
  return this.replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2').replace(/([a-z\d])([A-Z])/g, '$1_$2').replace(/-/g, '_').toLowerCase();
};

/**
Assumes the string is something like a file name and returns the
contents of the string without the extension.

    "neat.png".witouthExtension()
    # => "neat"

@name withoutExtension
@methodOf String#
@returns {String} A new string without the extension name.
*/

String.prototype.withoutExtension = function() {
  return this.replace(/\.[^\.]*$/, '');
};

String.prototype.toInt = function(base) {
  if (base == null) base = 10;
  return parseInt(this, base);
};

String.prototype.parseHex = function() {
  var alpha, hexString, i, rgb;
  hexString = this.replace(/#/, '');
  switch (hexString.length) {
    case 3:
    case 4:
      if (hexString.length === 4) {
        alpha = (parseInt(hexString.substr(3, 1), 16) * 0x11) / 255;
      } else {
        alpha = 1;
      }
      rgb = (function() {
        var _results;
        _results = [];
        for (i = 0; i <= 2; i++) {
          _results.push(parseInt(hexString.substr(i, 1), 16) * 0x11);
        }
        return _results;
      })();
      rgb.push(alpha);
      return rgb;
    case 6:
    case 8:
      if (hexString.length === 8) {
        alpha = parseInt(hexString.substr(6, 2), 16) / 255;
      } else {
        alpha = 1;
      }
      rgb = (function() {
        var _results;
        _results = [];
        for (i = 0; i <= 2; i++) {
          _results.push(parseInt(hexString.substr(2 * i, 2), 16));
        }
        return _results;
      })();
      rgb.push(alpha);
      return rgb;
  }
};

/*!
Math.uuid.js (v1.4)
http://www.broofa.com
mailto:robert@broofa.com

Copyright (c) 2010 Robert Kieffer
Dual licensed under the MIT and GPL licenses.
*/

/**
Generate a random uuid.

<code><pre>
   // No arguments  - returns RFC4122, version 4 ID
   Math.uuid()
=> "92329D39-6F5C-4520-ABFC-AAB64544E172"

   // One argument - returns ID of the specified length
   Math.uuid(15)     // 15 character ID (default base=62)
=> "VcydxgltxrVZSTV"

   // Two arguments - returns ID of the specified length, and radix. (Radix must be <= 62)
   Math.uuid(8, 2)  // 8 character ID (base=2)
=> "01001010"

   Math.uuid(8, 10) // 8 character ID (base=10)
=> "47473046"

   Math.uuid(8, 16) // 8 character ID (base=16)
=> "098F4D35"
</pre></code>

@name uuid
@methodOf Math
@param length The desired number of characters
@param radix  The number of allowable values for each character.
 */
(function() {
  // Private array of chars to use
  var CHARS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split(''); 

  Math.uuid = function (len, radix) {
    var chars = CHARS, uuid = [];
    radix = radix || chars.length;

    if (len) {
      // Compact form
      for (var i = 0; i < len; i++) uuid[i] = chars[0 | Math.random()*radix];
    } else {
      // rfc4122, version 4 form
      var r;

      // rfc4122 requires these characters
      uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-';
      uuid[14] = '4';

      // Fill in random data.  At i==19 set the high bits of clock sequence as
      // per rfc4122, sec. 4.1.5
      for (var i = 0; i < 36; i++) {
        if (!uuid[i]) {
          r = 0 | Math.random()*16;
          uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r];
        }
      }
    }

    return uuid.join('');
  };

  // A more performant, but slightly bulkier, RFC4122v4 solution.  We boost performance
  // by minimizing calls to random()
  Math.uuidFast = function() {
    var chars = CHARS, uuid = new Array(36), rnd=0, r;
    for (var i = 0; i < 36; i++) {
      if (i==8 || i==13 ||  i==18 || i==23) {
        uuid[i] = '-';
      } else if (i==14) {
        uuid[i] = '4';
      } else {
        if (rnd <= 0x02) rnd = 0x2000000 + (Math.random()*0x1000000)|0;
        r = rnd & 0xf;
        rnd = rnd >> 4;
        uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r];
      }
    }
    return uuid.join('');
  };

  // A more compact, but less performant, RFC4122v4 solution:
  Math.uuidCompact = function() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
      return v.toString(16);
    }).toUpperCase();
  };
})();

