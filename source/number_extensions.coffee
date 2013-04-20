###*
Returns the absolute value of this number.

    (-4).abs()
    # => 4

@name abs
@methodOf Number#
@returns {Number} The absolute value of the number.
###

###*
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
###

###*
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
###

###*
Returns this number rounded to the nearest integer.

    4.5.round()
    # => 5

    4.4.round()
    # => 4

@name round
@methodOf Number#
@returns {Number} The number rounded to the nearest integer.
###

["abs", "ceil", "floor", "round"].each (method) ->
  Number::[method] = ->
    Math[method](this)

###*
Get a bunch of points equally spaced around the unit circle.

    4.circularPoints (p) ->

    # p gets Point(1, 0), Point(0, 1), Point(-1, 0), Point(0, -1)

@name circularPoint
@methodOf Number#

###
Number::circularPoints = (block) ->
  n = this

  n.times (i) ->
    block(Point.fromAngle((i/n).turns), i)

###*
Returns a number whose value is limited to the given range.

    # limit the output of this computation to between 0 and 255
    (2 * 255).clamp(0, 255)
    # => 255

@name clamp
@methodOf Number#
@param {Number} min The lower boundary of the output range
@param {Number} max The upper boundary of the output range
@returns {Number} A number in the range [min, max]
###
Number::clamp = (min, max) ->
  if min? and max?
    Math.min(Math.max(this, min), max)
  else if min?
    Math.max(this, min)
  else if max?
    Math.min(this, max)
  else
    this

###*
A mod method useful for array wrapping. The range of the function is
constrained to remain in bounds of array indices.

    (-1).mod(5)
    # => 4

@name mod
@methodOf Number#
@param {Number} base
@returns {Number} An integer between 0 and (base - 1) if base is positive.
###
Number::mod = (base) ->
  result = this % base;

  if result < 0 && base > 0
    result += base

  return result

###*
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
###
Number::sign = ->
  if this > 0
    1
  else if this < 0
    -1
  else
    0

###*
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
###
Number::even = ->
  @mod(2) is 0

###*
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
###
Number::odd = ->
  not @even()

###*
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
###
Number::times = (iterator, context) ->
  i = -1

  while ++i < this
    iterator.call context, i

  return i

###*
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
###
Number::snap = (resolution) ->
  n = this / resolution; 1/1; # This is to fix broken regex in doc parser
  n.floor() * resolution

###*
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
###
Number::primeFactors = ->
  factors = []

  n = @floor()

  if n == 0
    return undefined

  if n < 0
    factors.push(-1)
    n /= -1

  i = 2
  iSquared = i * i

  while iSquared < n
    while (n % i) == 0
        factors.push i
        n /= i

    i += 1
    iSquared = i * i

  if n != 1
    factors.push n

  return factors

###*
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
###
Number::toColorPart = ->
  s = parseInt(@clamp(0, 255), 10).toString(16)

  if s.length == 1
    s = '0' + s

  return s

###*
Returns a number that is maxDelta closer to target.

    255.approach(0, 5)
    # => 250

    5.approach(0, 10)
    # => 0

@name approach
@methodOf Number#
@returns {Number} A number maxDelta toward target
###
Number::approach = (target, maxDelta) ->
  (target - this).clamp(-maxDelta, maxDelta) + this

###*
Returns a number that is closer to the target by the ratio.

    255.approachByRatio(0, 0.1)
    # => 229.5

@name approachByRatio
@methodOf Number#
@returns {Number} A number toward target by the ratio
###
Number::approachByRatio = (target, ratio) ->
  @approach(target, this * ratio)

###*
Returns a number that is closer to the target angle by the delta.

    Math.PI.approachRotation(0, Math.PI/4)
    # => 2.356194490192345 # this is (3/4) * Math.PI, which is (1/4) * Math.PI closer to 0 from Math.PI

@name approachRotation
@methodOf Number#
@returns {Number} A number toward the target angle by maxDelta
###
Number::approachRotation = (target, maxDelta) ->
  while target > this + Math.PI
    target -= Math.TAU

  while target < this - Math.PI
    target += Math.TAU

  return (target - this).clamp(-maxDelta, maxDelta) + this

###*
Constrains a rotation to between -PI and PI.

    (9/4 * Math.PI).constrainRotation()
    # => 0.7853981633974483 # this is (1/4) * Math.PI

@name constrainRotation
@methodOf Number#
@returns {Number} This number constrained between -PI and PI.
###
Number::constrainRotation = ->
  target = this

  while target > Math.PI
    target -= Math.TAU

  while target < -Math.PI
    target += Math.TAU

  return target

# TODO Test and document
Number::truncate = ->
  if this > 0
    @floor()
  else if this < 0
    @ceil()
  else
    this

###*
The mathematical d operator. Useful for simulating dice rolls.

@name d
@methodOf Number#
@returns {Number} The sum of rolling <code>this</code> many <code>sides</code>-sided dice
###
Number::d = (sides) ->
  sum = 0

  @times ->
    sum += rand(sides) + 1

  return sum

###*
Utility method to convert a number to a duration of seconds.

    3.seconds
    # => 3000

    setTimout doSometing, 3.seconds

@name seconds
@propertyOf Number#
@returns {Number} This number as a duration of seconds
###
unless 5.seconds
  Object.defineProperty Number::, 'seconds',
    get: ->
      this * 1000

unless 1.second
  Object.defineProperty Number::, 'second',
    get: ->
      this * 1000

###*
Utility method to convert a number to an amount of rotations.

    0.5.rotations
    # => 3.141592653589793

    I.rotation = 0.25.rotations

@name rotations
@propertyOf Number#
@returns {Number} This number as an amount of rotations
###
unless 5.rotations
  Object.defineProperty Number::, 'rotations',
    get: ->
      this * Math.TAU

unless 1.rotation
  Object.defineProperty Number::, 'rotation',
    get: ->
      this * Math.TAU

###*
Utility method to convert a number to an amount of rotations.

    0.5.turns
    # => 3.141592653589793

    I.rotation = 0.25.turns

    1.turn # => Math.TAU (aka 2 * Math.PI)

@name turns
@propertyOf Number#
@returns {Number} This number as an amount of rotation.
1 turn is one complete rotation.
###
unless 5.turns
  Object.defineProperty Number.prototype, 'turns',
    get: ->
      this * Math.TAU

unless 1.turn
  Object.defineProperty Number.prototype, 'turn',
    get: ->
      this * Math.TAU

###*
Utility method to convert a number to an amount of degrees.

    180.degrees
    # => 3.141592653589793

    I.rotation = 90.degrees

@name degrees
@propertyOf Number#
@returns {Number} This number as an amount of degrees
###
unless 2.degrees
  Object.defineProperty Number::, 'degrees',
    get: ->
      this * Math.TAU / 360

unless 1.degree
  Object.defineProperty Number::, 'degree',
    get: ->
      this * Math.TAU / 360

###*
The mathematical circle constant of 1 turn.

@name TAU
@fieldOf Math
###
Math.TAU = 2 * Math.PI
