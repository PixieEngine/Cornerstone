(->
  Rectangle = ({x, y, width, height}) ->

    return {
      __proto__: Rectangle::

      x: x || 0
      y: y || 0

      width: width || 0
      height: height || 0
    } 

  Rectangle:: =
    center: ->
      Point(@x + @width / 2, @y + @height / 2)

    equal: (other) ->
      @x == other.x && @y == other.y &&
      @width == other.width && @height == other.height

  Rectangle::__defineGetter__ 'left', ->
    @x

  Rectangle::__defineGetter__ 'right', ->
    @x + @width

  Rectangle::__defineGetter__ 'top', ->
    @y

  Rectangle::__defineGetter__ 'bottom', ->
    @y + @height

  (exports ? this)["Rectangle"] = Rectangle
)()

(->
  Rectangle = ({x, y, halfWidth, halfHeight}) ->

    return {
      __proto__: Rectangle::

      x: x || 0
      y: y || 0

      halfWidth: halfWidth || 0
      halfHeight: halfHeight || 0
    } 

  Rectangle:: =
    contains: (rectangle) ->
      rectangle.top >= @top and
      rectangle.bottom <= @bottom and
      rectangle.left >= @left and
      rectangle.right <= @right

    center: ->
      Point(@x, @y)

    equal: (other) ->
      @x is other.x and 
      @y is other.y and
      @halfWidth is other.halfWidth and 
      @halfWidth is other.halfHeight

    grow: (x, y) ->
      amount = x unless y?

      if amount
        return Rectangle
          x: @x
          y: @y
          halfWidth: @halfWidth + amount
          halfHeight: @halfHeight + amount
      else
        return Rectangle
          x: @x
          y: @y
          halfWidth: @halfWidth + x
          halfHeight: @halfHeight + y

    shrink: (x, y) ->
      if y?
        @grow(-x, -y)
      else
        @grow(-x, -x)

    overlaps: (rectangle) ->
      @top < rectangle.bottom and 
      @right > rectangle.left and
      @bottom > rectangle.top and
      @left < rectangle.right 

    outsideOf: (rectangle) ->
      not @contains(rectangle) and 
      not @overlaps(rectangle)

  Rectangle::__defineGetter__ 'left', ->
    @x - @halfWidth

  Rectangle::__defineGetter__ 'right', ->
    @x + @halfWidth

  Rectangle::__defineGetter__ 'top', ->
    @y - @halfHeight

  Rectangle::__defineGetter__ 'bottom', ->
    @y + @halfHeight

  (exports ? this)["Rectangle"] = Rectangle
)()


