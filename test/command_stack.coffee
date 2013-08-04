module "CommandStack"

test "undo on an empty stack returns undefined", ->
  commandStack = CommandStack()

  equals commandStack.undo(), undefined

test "redo on an empty stack returns undefined", ->
  commandStack = CommandStack()

  equals commandStack.redo(), undefined

test "executes commands", ->
  command =
    execute: ->
      ok true, "command executed"

  commandStack = CommandStack()

  commandStack.execute command

test "can undo", ->
  command =
    execute: ->
    undo: ->
      ok true, "command executed"

  commandStack = CommandStack()
  commandStack.execute command

  commandStack.undo()

test "can redo", ->
  command =
    execute: ->
      ok true, "command executed"
    undo: ->

  commandStack = CommandStack()
  commandStack.execute command

  commandStack.undo()
  commandStack.redo()

test "executes redone command once on redo", ->
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

test "cannot redo an obsolete future", ->
  Command = ->
    execute: ->
    undo: ->

  commandStack = CommandStack()
  commandStack.execute Command()
  commandStack.execute Command()

  commandStack.undo()
  commandStack.undo()

  equals commandStack.canRedo(), true

  commandStack.execute Command()

  equals commandStack.canRedo(), false

module()
