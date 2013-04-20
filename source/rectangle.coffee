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
