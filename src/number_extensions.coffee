###* 
 * Returns the absolute value of this number.
 * @type Number
 * @returns The absolute value of the number.
###
Number::abs = () ->
  Math.abs(this)
  
###*
 * Returns the mathematical ceiling of this number.
 * @type Number
 * @returns The number truncated to the nearest integer of greater than or equal value.
 * 
 * (4.9).ceil(); // => 5
 * (4.2).ceil(); // => 5
 * (-1.2).ceil(); // => -1
###
Number::ceil = ->
  Math.ceil(this)

###*
 * Returns the mathematical floor of this number.
 * @type Number
 * @returns The number truncated to the nearest integer of less than or equal value.
 * 
 * (4.9).floor(); // => 4
 * (4.2).floor(); // => 4
 * (-1.2).floor(); // => -2
###
Number::floor = ->
  Math.floor(this)

###*
 * Returns this number rounded to the nearest integer.
 * @type Number
 * @returns The number rounded to the nearest integer.
 * 
 * (4.5).round(); // => 5
 * (4.4).round(); // => 4
###
Number::round = ->
  Math.round(this)

###*
 * Returns a number whose value is limited to the given range.
 *
 * Example: limit the output of this computation to between 0 and 255
 * <pre>
 * (x * 255).clamp(0, 255)
 * </pre>
 *
 * @param {Number} min The lower boundary of the output range
 * @param {Number} max The upper boundary of the output range
 * @returns A number in the range [min, max]
 * @type Number
###
Number::clamp = (min, max) ->
  Math.min(Math.max(this, min), max)

###*
 * A mod method useful for array wrapping. The range of the function is
 * constrained to remain in bounds of array indices.
 *
 * <pre>
 * Example:
 * (-1).mod(5) === 4
 * </pre>
 *
 * @param {Number} base
 * @returns An integer between 0 and (base - 1) if base is positive.
 * @type Number
###
Number::mod = (base) ->
  result = this % base;

  if result < 0 && base > 0
    result += base

  return result

###*
 * Get the sign of this number as an integer (1, -1, or 0).
 * @type Number
 * @returns The sign of this number, 0 if the number is 0.
###
Number::sign = ->
  if this > 0
    1
  else if this < 0
    -1
  else 
    0

###*
 * Calls iterator the specified number of times, passing in the number of the 
 * current iteration as a parameter: 0 on first call, 1 on the second call, etc. 
 * 
 * @param {Function} iterator The iterator takes a single parameter, the number 
 * of the current iteration.
 * @param {Object} [context] The optional context parameter specifies an object
 * to treat as <code>this</code> in the iterator block.
 * 
 * @returns The number of times the iterator was called.
 * @type Number
###
Number::times = (iterator, context) ->
  i = -1

  while ++i < this
    iterator.call context, i

  return i

###*
 * Returns the the nearest grid resolution less than or equal to the number. 
 *
 *   EX: 
 *    (7).snap(8) => 0
 *    (4).snap(8) => 0
 *    (12).snap(8) => 8
 *
 * @param {Number} resolution The grid resolution to snap to.
 * @returns The nearest multiple of resolution lower than the number.
 * @type Number
###
Number::snap = (resolution) ->
  n = this / resolution; 1/1; # This is to fix broken regex in doc parser
  n.floor() * resolution

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
* @returns This number constrained between -PI and PI.
###
Number::constrainRotation = ->
  target = this

  while target > Math.PI
    target -= Math.TAU

  while target < -Math.PI
    target += MATH.TAU
      
  return target

Number::d = (sides) ->
  sum = 0

  this.times ->
    sum += rand(sides) + 1

  return sum

###* 
* The mathematical circle constant of 1 turn.
* @name TAU
* @fieldOf Math
###
Math.TAU = 2 * Math.PI

