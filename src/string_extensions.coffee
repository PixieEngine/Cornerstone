String::constantize = () ->
  if this.match /[A-Z][A-Za-z0-9]*/
    eval("var that = #{this}")
    that
  else
    undefined

String::parse = () ->
  try
    return JSON.parse(this)
  catch e
    return this

String::blank = ->
  /^\s*$/.test(this)

