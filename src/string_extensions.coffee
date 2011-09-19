###*
Returns true if this string only contains whitespace characters.

<code><pre>
"".blank()
# => true

"hello".blank()
# => false

"   ".blank()
# => true
</pre></code>

@name blank
@methodOf String#
@returns {Boolean} Whether or not this string is blank.
###
String::blank = ->
  /^\s*$/.test(this)

###*
Returns a new string that is a camelCase version.

<code><pre>
"camel_case".camelize()
"camel-case".camelize()
"camel case".camelize()

# => "camelCase"
</pre></code>

@name camelize
@methodOf String#
@returns {String} A new string. camelCase version of `this`. 
###
String::camelize = ->
  this.trim().replace /(\-|_|\s)+(.)?/g, (match, separator, chr) ->
    if chr then chr.toUpperCase() else ''

###*
Returns a new string with the first letter capitalized and the rest lower cased.

<code><pre>
"capital".capitalize()
"cAPITAL".capitalize()
"cApItAl".capitalize()
"CAPITAL".capitalize()

# => "Capital"
</pre></code>

@name capitalize
@methodOf String#
@returns {String} A new string. Capitalized version of `this`
###
String::capitalize = ->
  this.charAt(0).toUpperCase() + this.substring(1).toLowerCase()

###*
Return the class or constant named in this string.

<code><pre>

"Constant".constantize()
# => Constant
# notice this isn't a string. Useful for calling methods on class named Constant.
</pre></code>

@name constantize
@methodOf String#
@returns {Object} The class or constant named in this string.
###
String::constantize = ->
  if this.match /[A-Z][A-Za-z0-9]*/
    eval("var that = #{this}")
    that
  else
    throw "String#constantize: '#{this}' is not a valid constant name."

###*
Returns a new string that is a more human readable version.

@name humanize
@methodOf String#
###
String::humanize = ->
  this.replace(/_id$/, "").replace(/_/g, " ").capitalize()

###*
Returns true.

@name isString
@methodOf String#
@type Boolean
@returns true
###
String::isString = ->
  true

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
    JSON.parse(this.toString())
  catch e
    this.toString()

###*
Returns a new string in Title Case.
@name titleize
@methodOf String#
###
String::titleize = ->
  this.split(/[- ]/).map (word) ->
    word.capitalize()
  .join(' ')

###*
Underscore a word, changing camelCased with under_scored.
@name underscore
@methodOf String#
###
String::underscore = ->
  this.replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2')
    .replace(/([a-z\d])([A-Z])/g, '$1_$2')
    .replace(/-/g, '_')
    .toLowerCase()

###*
Assumes the string is something like a file name and returns the 
contents of the string without the extension.

"neat.png".witouthExtension() => "neat"

@name withoutExtension
@methodOf String#
###
String::withoutExtension = ->
  this.replace(/\.[^\.]*$/, '')

