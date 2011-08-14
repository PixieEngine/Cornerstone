( ->
  ###*
  Create a new point with given x and y coordinates. If no arguments are given
  defaults to (0, 0).
  @name Point
  @param {Number} [x]
  @param {Number} [y]
  @constructor
  ###
  Point = (x, y) ->
    __proto__: Point::

    ###*
    The x coordinate of this point.
    @name x
    @fieldOf Point#
    ###
    x: x || 0
    ###*
    The y coordinate of this point.
    @name y
    @fieldOf Point#
    ###
    y: y || 0

  Point:: =
    ###*
    Creates a copy of this point.

    @name copy
    @methodOf Point#
    @returns A new point with the same x and y value as this point.
    @type Point
    ###
    copy: ->
      Point(this.x, this.y)

    ###*
    Adds a point to this one and returns the new point. You may
    also use a two argument call like <code>point.add(x, y)</code>
    to add x and y values without a second point object.
    @name add
    @methodOf Point#

    @param {Point} other The point to add this point to.
    @returns A new point, the sum of both.
    @type Point
    ###
    add: (first, second) ->
      this.copy().add$(first, second)

    add$: (first, second) ->
      if second?
        this.x += first
        this.y += second
      else
        this.x += first.x
        this.y += first.y

      this

    ###*
    Subtracts a point to this one and returns the new point.
    @name subtract
    @methodOf Point#

    @param {Point} other The point to subtract from this point.
    @returns A new point, this - other.
    @type Point
    ###
    subtract: (first, second) ->
      this.copy().subtract$(first, second)

    subtract$: (first, second) ->
      if second?
        this.x -= first
        this.y -= second
      else
        this.x -= first.x
        this.y -= first.y

      this

    ###*
    Scale this Point (Vector) by a constant amount.
    @name scale
    @methodOf Point#

    @param {Number} scalar The amount to scale this point by.
    @returns A new point, this * scalar.
    @type Point
    ###
    scale: (scalar) ->
      this.copy().scale$(scalar)

    scale$: (scalar) ->
      this.x *= scalar
      this.y *= scalar

      this

    ###*
    The norm of a vector is the unit vector pointing in the same direction. This method
    treats the point as though it is a vector from the origin to (x, y).
    @name norm
    @methodOf Point#

    @returns The unit vector pointing in the same direction as this vector.
    @type Point
    ###
    norm: (length=1.0) ->
      this.copy().norm$(length)

    norm$: (length=1.0) ->
      if m = this.length()
        this.scale$(length/m)
      else
        this

    ###*
    Floor the x and y values, returning a new point.

    @name floor
    @methodOf Point#
    @returns A new point, with x and y values each floored to the largest previous integer.
    @type Point
    ###
    floor: ->
      this.copy().floor$()

    floor$: ->
      this.x = this.x.floor()
      this.y = this.y.floor()

      this

    ###*
    Determine whether this point is equal to another point.
    @name equal
    @methodOf Point#

    @param {Point} other The point to check for equality.
    @returns true if the other point has the same x, y coordinates, false otherwise.
    @type Boolean
    ###
    equal: (other) ->
      this.x == other.x && this.y == other.y

    ###*
    Computed the length of this point as though it were a vector from (0,0) to (x,y)
    @name length
    @methodOf Point#

    @returns The length of the vector from the origin to this point.
    @type Number
    ###
    length: ->
      Math.sqrt(this.dot(this))

    ###*
    Calculate the magnitude of this Point (Vector).
    @name magnitude
    @methodOf Point#

    @returns The magnitude of this point as if it were a vector from (0, 0) -> (x, y).
    @type Number
    ###
    magnitude: ->
      this.length()

    ###*
    Returns the direction in radians of this point from the origin.
    @name direction
    @methodOf Point#

    @type Number
    ###
    direction: ->
      Math.atan2(this.y, this.x)

    ###*
    Calculate the dot product of this point and another point (Vector).
    @name dot
    @methodOf Point#

    @param {Point} other The point to dot with this point.
    @returns The dot product of this point dot other as a scalar value.
    @type Number
    ###
    dot: (other) ->
      this.x * other.x + this.y * other.y

    ###*
    Calculate the cross product of this point and another point (Vector). 
    Usually cross products are thought of as only applying to three dimensional vectors,
    but z can be treated as zero. The result of this method is interpreted as the magnitude 
    of the vector result of the cross product between [x1, y1, 0] x [x2, y2, 0]
    perpendicular to the xy plane.
    @name cross
    @methodOf Point#

    @param {Point} other The point to cross with this point.
    @returns The cross product of this point with the other point as scalar value.
    @type Number
    ###
    cross: (other) ->
      this.x * other.y - other.x * this.y

    ###*
    Computed the Euclidean between this point and another point.
    @name distance
    @methodOf Point#

    @param {Point} other The point to compute the distance to.
    @returns The distance between this point and another point.
    @type Number
    ###
    distance: (other) ->
      Point.distance(this, other)

  ###*
  @name distance
  @methodOf Point
  @param {Point} p1
  @param {Point} p2
  @type Number
  @returns The Euclidean distance between two points.
  ###
  Point.distance = (p1, p2) ->
    Math.sqrt(Math.pow(p2.x - p1.x, 2) + Math.pow(p2.y - p1.y, 2))

  ###*
  Construct a point on the unit circle for the given angle.

  @name fromAngle
  @methodOf Point

  @param {Number} angle The angle in radians
  @type Point
  @returns The point on the unit circle.
  ###
  Point.fromAngle = (angle) ->
    Point(Math.cos(angle), Math.sin(angle))

  ###*
  If you have two dudes, one standing at point p1, and the other
  standing at point p2, then this method will return the direction
  that the dude standing at p1 will need to face to look at p2.

  @name direction
  @methodOf Point

  @param {Point} p1 The starting point.
  @param {Point} p2 The ending point.
  @type Number
  @returns The direction from p1 to p2 in radians.
  ###
  Point.direction = (p1, p2) ->
    Math.atan2(
      p2.y - p1.y,
      p2.x - p1.x
    )

  ###*
  @name ZERO
  @fieldOf Point

  @type Point
  ###
  Point.ZERO = Point()

  if Object.freeze
    Object.freeze Point.ZERO

  window["Point"] = Point
)()

