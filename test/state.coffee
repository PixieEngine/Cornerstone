test "State", ->
  callback = Callback {}, "Test Machine", ->
    console.log "testing"
    
  equals callback, ! null, "callback shouldn't be null"

