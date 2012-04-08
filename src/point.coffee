( ->
  ###*
  Create a new point with given x and y coordinates. If no arguments are given
  defaults to (0, 0).

  <code><pre>
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
  </pre></code>

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

    ###
    clamp: (n) ->
      @copy().clamp()

    clamp$: (n) ->
      @norm$(n) if @magnitude() > n

    ###*
    Creates a copy of this point.

    @name copy
    @methodOf Point#
    @returns {Point} A new point with the same x and y value as this point.

    <code><pre>
    point = Point(1, 1)
    pointCopy = point.copy()

    point.equal(pointCopy)
    # => true

    point == pointCopy
    # => false     
    </pre></code>
    ###
    copy: ->
      Point(@x, @y)

    ###*
    Adds a point to this one and returns the new point. You may
    also use a two argument call like <code>point.add(x, y)</code>
    to add x and y values without a second point object.

    <code><pre>
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
    </pre></code>

    @name add
    @methodOf Point#
    @param {Point} other The point to add this point to.
    @returns {Point} A new point, the sum of both.
    ###
    add: (first, second) ->
      @copy().add$(first, second)

    ###*
    Adds a point to this one, returning a modified point. You may
    also use a two argument call like <code>point.add(x, y)</code>
    to add x and y values without a second point object.

    <code><pre>
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
    </pre></code>

    @name add$
    @methodOf Point#
    @param {Point} other The point to add this point to.
    @returns {Point} The sum of both points.
    ###
    add$: (first, second) ->
      if second?
        @x += first
        @y += second
      else
        @x += first.x
        @y += first.y

      return this

    ###*
    Subtracts a point to this one and returns the new point.

    <code><pre>
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
    </pre></code>

    @name subtract
    @methodOf Point#
    @param {Point} other The point to subtract from this point.
    @returns {Point} A new point, this - other.
    ###
    subtract: (first, second) ->
      @copy().subtract$(first, second)

    ###*
    Subtracts a point to this one and returns the new point.

    <code><pre>
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
    </pre></code>

    @name subtract$
    @methodOf Point#
    @param {Point} other The point to subtract from this point.
    @returns {Point} The difference of the two points.
    ###
    subtract$: (first, second) ->
      if second?
        @x -= first
        @y -= second
      else
        @x -= first.x
        @y -= first.y

      return this

    ###*
    Scale this Point (Vector) by a constant amount.

    <code><pre>
    point = Point(5, 6).scale(2)

    point.x
    # => 10

    point.y
    # => 12
    </pre></code>

    @name scale
    @methodOf Point#
    @param {Number} scalar The amount to scale this point by.
    @returns {Point} A new point, this * scalar.
    ###
    scale: (scalar) ->
      @copy().scale$(scalar)

    ###*
    Scale this Point (Vector) by a constant amount. Modifies the point in place.

    <code><pre>
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
    </pre></code>

    @name scale$
    @methodOf Point#
    @param {Number} scalar The amount to scale this point by.
    @returns {Point} this * scalar.
    ###
    scale$: (scalar) ->
      @x *= scalar
      @y *= scalar

      return this

    ###*
    The norm of a vector is the unit vector pointing in the same direction. This method
    treats the point as though it is a vector from the origin to (x, y).

    <code><pre>
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
    </pre></code>

    @name norm
    @methodOf Point#
    @returns {Point} The unit vector pointing in the same direction as this vector.
    ###
    norm: (length=1.0) ->
      @copy().norm$(length)

    ###*
    The norm of a vector is the unit vector pointing in the same direction. This method
    treats the point as though it is a vector from the origin to (x, y). Modifies the point in place.

    <code><pre>
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
    </pre></code>

    @name norm$
    @methodOf Point#
    @returns {Point} The unit vector pointing in the same direction as this vector.
    ###
    norm$: (length=1.0) ->
      if m = @length()
        @scale$(length/m)
      else
        this

    ###*
    Floor the x and y values, returning a new point.

    <code><pre>
    point = Point(3.4, 5.8).floor()

    point.x
    # => 3

    point.y
    # => 5
    </pre></code>

    @name floor
    @methodOf Point#
    @returns {Point} A new point, with x and y values each floored to the largest previous integer.
    ###
    floor: ->
      @copy().floor$()

    ###*
    Floor the x and y values, returning a modified point.

    <code><pre>
    point = Point(3.4, 5.8)
    point.floor$()

    point.x
    # => 3

    point.y
    # => 5
    </pre></code>

    @name floor$
    @methodOf Point#
    @returns {Point} A modified point, with x and y values each floored to the largest previous integer.
    ###
    floor$: ->
      @x = @x.floor()
      @y = @y.floor()

      return this

    ###*
    Determine whether this point is equal to another point.

    <code><pre>
    pointA = Point(2, 3)
    pointB = Point(2, 3)
    pointC = Point(4, 5)

    pointA.equal(pointB)
    # => true

    pointA.equal(pointC)
    # => false
    </pre></code>

    @name equal
    @methodOf Point#
    @param {Point} other The point to check for equality.
    @returns {Boolean} true if the other point has the same x, y coordinates, false otherwise.
    ###
    equal: (other) ->
      @x == other.x && @y == other.y

    ###*
    Computed the length of this point as though it were a vector from (0,0) to (x,y).

    <code><pre>
    point = Point(5, 7)

    point.length()
    # => 8.602325267042627
    </pre></code>

    @name length
    @methodOf Point#
    @returns {Number} The length of the vector from the origin to this point.
    ###
    length: ->
      Math.sqrt(@dot(this))

    ###*
    Calculate the magnitude of this Point (Vector).

    <code><pre>
    point = Point(5, 7)

    point.magnitude()
    # => 8.602325267042627
    </pre></code>

    @name magnitude
    @methodOf Point#
    @returns {Number} The magnitude of this point as if it were a vector from (0, 0) -> (x, y).
    ###
    magnitude: ->
      @length()

    ###*
    Returns the direction in radians of this point from the origin.

    <code><pre>
    point = Point(0, 1)

    point.direction()
    # => 1.5707963267948966 # Math.PI / 2
    </pre></code>

    @name direction
    @methodOf Point#
    @returns {Number} The direction in radians of this point from the origin
    ###
    direction: ->
      Math.atan2(@y, @x)

    ###*
    Calculate the dot product of this point and another point (Vector).
    @name dot
    @methodOf Point#
    @param {Point} other The point to dot with this point.
    @returns {Number} The dot product of this point dot other as a scalar value.
    ###
    dot: (other) ->
      @x * other.x + @y * other.y

    ###*
    Calculate the cross product of this point and another point (Vector). 
    Usually cross products are thought of as only applying to three dimensional vectors,
    but z can be treated as zero. The result of this method is interpreted as the magnitude 
    of the vector result of the cross product between [x1, y1, 0] x [x2, y2, 0]
    perpendicular to the xy plane.

    @name cross
    @methodOf Point#
    @param {Point} other The point to cross with this point.
    @returns {Number} The cross product of this point with the other point as scalar value.
    ###
    cross: (other) ->
      @x * other.y - other.x * @y

    ###*
    Compute the Euclidean distance between this point and another point.

    <code><pre>
    pointA = Point(2, 3)
    pointB = Point(9, 2)

    pointA.distance(pointB)
    # => 7.0710678118654755 # Math.sqrt(50)
    </pre></code>

    @name distance
    @methodOf Point#
    @param {Point} other The point to compute the distance to.
    @returns {Number} The distance between this point and another point.
    ###
    distance: (other) ->
      Point.distance(this, other)

    ###*
    @name toString
    @methodOf Point#
    @returns {String} A string representation of this point.
    ###
    toString: ->
      "Point(#{@x}, #{@y})"

  ###*
  Compute the Euclidean distance between two points.

  <code><pre>
  pointA = Point(2, 3)
  pointB = Point(9, 2)

  Point.distance(pointA, pointB)
  # => 7.0710678118654755 # Math.sqrt(50)
  </pre></code>

  @name distance
  @fieldOf Point
  @param {Point} p1
  @param {Point} p2
  @returns {Number} The Euclidean distance between two points.
  ###
  Point.distance = (p1, p2) ->
    Math.sqrt(Point.distanceSquared(p1, p2))

  ###*
  <code><pre>
  pointA = Point(2, 3)
  pointB = Point(9, 2)

  Point.distanceSquared(pointA, pointB)
  # => 50
  </pre></code>

  @name distanceSquared
  @fieldOf Point
  @param {Point} p1
  @param {Point} p2
  @returns {Number} The square of the Euclidean distance between two points.
  ###
  Point.distanceSquared = (p1, p2) ->
    Math.pow(p2.x - p1.x, 2) + Math.pow(p2.y - p1.y, 2)

  ###*
  @name interpolate
  @fieldOf Point

  @param {Point} p1
  @param {Point} p2
  @param {Number} t
  @returns {Point} A point along the path from p1 to p2
  ###
  Point.interpolate = (p1, p2, t) ->
    p2.subtract(p1).scale(t).add(p1)

  ###*
  Construct a point on the unit circle for the given angle.

  <code><pre>
  point = Point.fromAngle(Math.PI / 2)

  point.x
  # => 0

  point.y
  # => 1
  </pre></code>

  @name fromAngle
  @fieldOf Point
  @param {Number} angle The angle in radians
  @returns {Point} The point on the unit circle.
  ###
  Point.fromAngle = (angle) ->
    Point(Math.cos(angle), Math.sin(angle))

  ###*
  If you have two dudes, one standing at point p1, and the other
  standing at point p2, then this method will return the direction
  that the dude standing at p1 will need to face to look at p2.

  <code><pre>
  p1 = Point(0, 0)
  p2 = Point(7, 3)

  Point.direction(p1, p2)
  # => 0.40489178628508343
  </pre></code>

  @name direction
  @fieldOf Point
  @param {Point} p1 The starting point.
  @param {Point} p2 The ending point.
  @returns {Number} The direction from p1 to p2 in radians.
  ###
  Point.direction = (p1, p2) ->
    Math.atan2(
      p2.y - p1.y,
      p2.x - p1.x
    )

  ###*
  The centroid of a set of points is their arithmetic mean.

  @name centroid
  @methodOf Point
  @param points... The points to find the centroid of.
  ###
  Point.centroid = (points...) ->
    points.inject Point(0, 0), (sumPoint, point) ->
      sumPoint.add(point)
    .scale(1/points.length)

  ###*
  @name ZERO
  @fieldOf Point
  @returns {Point} The point (0, 0)
  ###
  Point.ZERO = Point(0, 0)

  ###*
  @name LEFT
  @fieldOf Point
  @returns {Point} The point (-1, 0)
  ###
  Point.LEFT = Point(-1, 0)

  ###*
  @name RIGHT
  @fieldOf Point
  @returns {Point} The point (1, 0)
  ###
  Point.RIGHT = Point(1, 0)

  ###*
  @name UP
  @fieldOf Point
  @returns {Point} The point (0, -1)
  ###
  Point.UP = Point(0, -1)

  ###*
  @name DOWN
  @fieldOf Point
  @returns {Point} The point (0, 1)
  ###
  Point.DOWN = Point(0, 1)

  if Object.freeze
    Object.freeze Point.ZERO
    Object.freeze Point.LEFT
    Object.freeze Point.RIGHT
    Object.freeze Point.UP
    Object.freeze Point.DOWN

  (exports ? this)["Point"] = Point
)()

