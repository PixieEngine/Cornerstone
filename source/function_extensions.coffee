Object.extend Function.prototype,
  once: ->
    func = this

    ran = false
    memo = undefined

    return ->
      return memo if ran
      ran = true

      return memo = func.apply(this, arguments)

  ###*
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
  ###
  debounce: (wait) ->
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

  delay: (wait, args...) ->
    func = this

    setTimeout ->
      func.apply(null, args)
    , wait

  defer: (args...) ->
    this.delay.apply this, [1].concat(args)

Object.extend Function,
  identity: (x) ->
    x

  noop: ->
