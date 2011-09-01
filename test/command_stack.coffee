module "CommandStack"

test "undo on an empty stack returns undefined", ->
  commandStack = CommandStack()

  equals commandStack.undo(), undefined

test "redo on an empty stack returns undefined", ->
  commandStack = CommandStack()

  equals commandStack.redo(), undefined

test "executes commands", 1, ->
  command =
    execute: ->
      ok true, "command executed"

  commandStack = CommandStack()

  commandStack.execute command

test "can undo", 1, ->
  command =
    execute: ->
    undo: ->
      ok true, "command executed"

  commandStack = CommandStack()
  commandStack.execute command

  commandStack.undo()

test "can redo", 2, ->
  command =
    execute: ->
      ok true, "command executed"
    undo: ->

  commandStack = CommandStack()
  commandStack.execute command

  commandStack.undo()
  commandStack.redo()

test "executes redone command once on redo", 4, ->
  command =
    execute: ->
      ok true, "command executed"
    undo: ->

  commandStack = CommandStack()
  commandStack.execute command

  commandStack.undo()
  commandStack.redo()

  equals commandStack.redo(), undefined
  equals commandStack.redo(), undefined

test "command is returned when undone", ->
  command =
    execute: ->
    undo: ->

  commandStack = CommandStack()
  commandStack.execute command

  equals commandStack.undo(), command, "Undone command is returned"

test "command is returned when redone", ->
  command =
    execute: ->
    undo: ->

  commandStack = CommandStack()
  commandStack.execute command
  commandStack.undo()

  equals commandStack.redo(), command, "Redone command is returned"

module()