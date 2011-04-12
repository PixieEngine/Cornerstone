###*
Return the class or constant named in this string.

@name constantize
@methodOf String#

@returns The class or constant named in this string.
@type Object
###
String::constantize = ->
  if this.match /[A-Z][A-Za-z0-9]*/
    eval("var that = #{this}")
    that
  else
    undefined

###*
Parse this string as though it is JSON and return the object it represents. If it
is not valid JSON returns the string itself.

@name parse
@methodOf String#

@returns Returns an object from the JSON this string contains. If it
is not valid JSON returns the string itself.
@type Object
###
String::parse = () ->
  try
    return JSON.parse(this)
  catch e
    return this

###*
Returns true if this string only contains whitespace characters.

@name blank
@methodOf String#

@returns Whether or not this string is blank.
@type Boolean
###
String::blank = ->
  /^\s*$/.test(this)

