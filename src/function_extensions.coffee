Function::withBefore = (interception) -> 
  method = this
  () ->
    interception.apply this, arguments
    method.apply this, arguments

Function::withAfter = (interception) -> 
  method = this
  () ->
    result = method.apply this, arguments
    interception.apply this, arguments
    return result

###*
Calling a debounced function will postpone its execution until after 
wait milliseconds have elapsed since the last time the function was 
invoked. Useful for implementing behavior that should only happen after 
the input has stopped arriving. For example: rendering a preview of a 
Markdown comment, recalculating a layout after the window has stopped 
being resized...

<code><pre>
lazyLayout = calculateLayout.debounce(300)
$(window).resize(lazyLayout)
</pre></code>

@name debounce
@methodOf Function#
@returns {Function} The debounced version of this function.
###
Function::debounce = (wait) ->
  timeout = null
  func = this

  return ->
    context = this
    args = arguments

    later = ->
      timeout = null
      func.apply(context, args)

    clearTimeout(timeout)
    timeout = setTimeout(later, wait)

