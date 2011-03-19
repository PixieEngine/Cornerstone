test "State", ->
  callback = Callback{}, "Test Machine", ->
    console.log "testing"
    
  equals color.r(), 0, "default red channel is 0"

