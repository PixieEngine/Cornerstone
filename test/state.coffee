test "State", ->
  callback = Callback {}, "Test Machine", ->
    console.log "testing"
    
  equals callback != null, true, "callback shouldn't be null"

