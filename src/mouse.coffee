window.Mouse = (() ->
  Mouse = 
    left:false
    right:false
    middle:false

  buttons = [null, "left", "middle", "right"]

  set_button = (index, state) ->
    button_name = buttons[index]

    if button_name
      Mouse[button_name] = state

  $(document).mousedown (event) ->
    set_button event.which, true

  $(document).mouseup (event) ->
    set_button event.which, false

  $(document).mousemove (event) ->
    #TODO: Use canvas local x and y
    x = event.pageX
    y = event.pageY

    Mouse.x = x
    Mouse.y = y

  Mouse
)()

