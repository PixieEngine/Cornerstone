###* 
Returns the absolute value of this number.

@name abs
@methodOf Number#

@type Number
@returns The absolute value of the number.
###
Number::abs = () ->
  Math.abs(this)

###*
Returns the mathematical ceiling of this number.

@name ceil
@methodOf Number#

@type Number
@returns The number truncated to the nearest integer of greater than or equal value.

(4.9).ceil() # => 5
(4.2).ceil() # => 5
(-1.2).ceil() # => -1
###
Number::ceil = ->
  Math.ceil(this)

###*
Returns the mathematical floor of this number.

@name floor
@methodOf Number#

@type Number
@returns The number truncated to the nearest integer of less than or equal value.

(4.9).floor() # => 4
(4.2).floor() # => 4
(-1.2).floor() # => -2
###
Number::floor = ->
  Math.floor(this)

###*
Returns this number rounded to the nearest integer.

@name round
@methodOf Number#

@type Number
@returns The number rounded to the nearest integer.

(4.5).round() # => 5
(4.4).round() # => 4
###
Number::round = ->
  Math.round(this)

###*
Returns a number whose value is limited to the given range.

Example: limit the output of this computation to between 0 and 255
<pre>
(x * 255).clamp(0, 255)
</pre>

@name clamp
@methodOf Number#

@param {Number} min The lower boundary of the output range
@param {Number} max The upper boundary of the output range

@returns A number in the range [min, max]
@type Number
###
Number::clamp = (min, max) ->
  Math.min(Math.max(this, min), max)

###*
A mod method useful for array wrapping. The range of the function is
constrained to remain in bounds of array indices.

<pre>
Example:
(-1).mod(5) == 4
</pre>

@name mod
@methodOf Number#

@param {Number} base
@returns An integer between 0 and (base - 1) if base is positive.
@type Number
###
Number::mod = (base) ->
  result = this % base;

  if result < 0 && base > 0
    result += base

  return result

###*
Get the sign of this number as an integer (1, -1, or 0).

@name sign
@methodOf Number#

@type Number
@returns The sign of this number, 0 if the number is 0.
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

@name even
@methodOf Number#

@type Boolean
@returns true if this number is an even integer, false otherwise.
###
Number::even = ->
  this % 2 == 0

###*
Returns true if this number is odd (has remainder of 1 when divided by 2).

@name odd
@methodOf Number#

@type Boolean
@returns true if this number is an odd integer, false otherwise.
###
Number::odd = ->
  if this > 0
    this % 2 == 1
  else
    this % 2 == -1

###*
Calls iterator the specified number of times, passing in the number of the 
current iteration as a parameter: 0 on first call, 1 on the second call, etc. 

@name times
@methodOf Number#

@param {Function} iterator The iterator takes a single parameter, the number 
of the current iteration.
@param {Object} [context] The optional context parameter specifies an object
to treat as <code>this</code> in the iterator block.

@returns The number of times the iterator was called.
@type Number
###
Number::times = (iterator, context) ->
  i = -1

  while ++i < this
    iterator.call context, i

  return i

###*
Returns the the nearest grid resolution less than or equal to the number. 

  EX: 
   (7).snap(8) => 0
   (4).snap(8) => 0
   (12).snap(8) => 8

@name snap
@methodOf Number#

@param {Number} resolution The grid resolution to snap to.
@returns The nearest multiple of resolution lower than the number.
@type Number
###
Number::snap = (resolution) ->
  n = this / resolution; 1/1; # This is to fix broken regex in doc parser
  n.floor() * resolution

###*
In number theory, integer factorization or prime factorization is the
breaking down of a composite number into smaller non-trivial divisors,
which when multiplied together equal the original integer.

Floors the number for purposes of factorization.

@name primeFactors
@methodOf Number#

@returns An array containing the factorization of this number.
@type Array
###
Number::primeFactors = ->
  factors = []

  n = Math.floor(this)

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

Number::toColorPart = ->
  s = parseInt(this.clamp(0, 255), 10).toString(16)

  if s.length == 1
    s = '0' + s

  return s

Number::approach = (target, maxDelta) ->
  (target - this).clamp(-maxDelta, maxDelta) + this

Number::approachByRatio = (target, ratio) ->
  this.approach(target, this * ratio)

Number::approachRotation = (target, maxDelta) ->
  while target > this + Math.PI
    target -= Math.TAU

  while target < this - Math.PI
    target += Math.TAU

  return (target - this).clamp(-maxDelta, maxDelta) + this

###*
Constrains a rotation to between -PI and PI.

@name constrainRotation
@methodOf Number#

@returns This number constrained between -PI and PI.
@type Number
###
Number::constrainRotation = ->
  target = this

  while target > Math.PI
    target -= Math.TAU

  while target < -Math.PI
    target += Math.TAU

  return target

Number::d = (sides) ->
  sum = 0

  this.times ->
    sum += rand(sides) + 1

  return sum

###* 
The mathematical circle constant of 1 turn.

@name TAU
@fieldOf Math
###
Math.TAU = 2 * Math.PI

