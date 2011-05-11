window.requestAnimationFrame ||= 
  window.webkitRequestAnimationFrame || 
  window.mozRequestAnimationFrame    || 
  window.oRequestAnimationFrame      || 
  window.msRequestAnimationFrame     || 
  (callback, element) ->
    window.setTimeout( ->
      callback(new Date().getTime())
    , 1000 / 60)

