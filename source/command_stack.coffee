CommandStack = ->
  stack = []
  index = 0

  execute: (command) ->
    stack[index] = command
    command.execute()

    # Be sure to blast obsolete redos
    stack.length = index += 1

  undo: ->
    if @canUndo()
      index -= 1

      command = stack[index]
      command.undo()

      return command

  redo: ->
    if @canRedo()
      command = stack[index]
      command.execute()

      index += 1

      return command

  current: ->
    stack[index-1]

  canUndo: ->
    index > 0

  canRedo: ->
    stack[index]?

(global ? this)["CommandStack"] = CommandStack
