###*
Returns true if this string only contains whitespace characters.

    "".blank()
    # => true
    
    "hello".blank()
    # => false
    
    "   ".blank()
    # => true

@name blank
@methodOf String#
@returns {Boolean} Whether or not this string is blank.
###
String::blank = ->
  /^\s*$/.test(this)

###*
Returns a new string that is a camelCase version.

    "camel_case".camelize()
    "camel-case".camelize()
    "camel case".camelize()
    
    # => "camelCase"

@name camelize
@methodOf String#
@returns {String} A new string. camelCase version of `this`. 
###
String::camelize = ->
  this.trim().replace /(\-|_|\s)+(.)?/g, (match, separator, chr) ->
    if chr then chr.toUpperCase() else ''

###*
Returns a new string with the first letter capitalized and the rest lower cased.

    "capital".capitalize()
    "cAPITAL".capitalize()
    "cApItAl".capitalize()
    "CAPITAL".capitalize()
    
    # => "Capital"

@name capitalize
@methodOf String#
@returns {String} A new string. Capitalized version of `this`
###
String::capitalize = ->
  this.charAt(0).toUpperCase() + this.substring(1).toLowerCase()

###*
Return the class or constant named in this string.

    
    "Constant".constantize()
    # => Constant
    # notice this isn't a string. Useful for calling methods on class with the same name as `this`.

@name constantize
@methodOf String#
@returns {Object} The class or constant named in this string.
###
String::constantize = ->
  target = exports ? window

  target = target[item] for item in this.split '.'

  return target

###*
Get the file extension of a string.

    "README.md".extension() # => "md"
    "README".extension() # => ""

@name extension
@methodOf String#
@returns {String} File extension
###
String::extension = ->
  if 
  return .last() || '';

###*
Returns a new string that is a more human readable version.

    "player_id".humanize()
    # => "Player"
    
    "player_ammo".humanize()
    # => "Player ammo"

@name humanize
@methodOf String#
@returns {String} A new string. Replaces _id and _ with "" and capitalizes the word.
###
String::humanize = ->
  this.replace(/_id$/, "").replace(/_/g, " ").capitalize()

###*
Returns true.

@name isString
@methodOf String#
@returns {Boolean} true
###
String::isString = ->
  true

###*
Parse this string as though it is JSON and return the object it represents. If it
is not valid JSON returns the string itself.

    # this is valid json, so an object is returned
    '{"a": 3}'.parse()
    # => {a: 3}
    
    # double quoting instead isn't valid JSON so a string is returned
    "{'a': 3}".parse()
    # => "{'a': 3}"
    

@name parse
@methodOf String#
@returns {Object} Returns an object from the JSON this string contains. If it is not valid JSON returns the string itself.
###
String::parse = () ->
  try
    JSON.parse(this.toString())
  catch e
    this.toString()

###*
Returns true if this string starts with the given string.

@name startsWith
@methodOf String#
@param {String} str The string to check.

@returns {Boolean} True if this string starts with the given string, false otherwise.
###
String::startsWith = (str) ->
  @lastIndexOf(str, 0) is 0

###*
Returns a new string in Title Case.

    "title-case".titleize()
    # => "Title Case"
    
    "title case".titleize()
    # => "Title Case"

@name titleize
@methodOf String#
@returns {String} A new string. Title Cased.
###
String::titleize = ->
  this.split(/[- ]/).map (word) ->
    word.capitalize()
  .join(' ')

###*
Underscore a word, changing camelCased with under_scored.

    "UNDERScore".underscore()
    # => "under_score"
    
    "UNDER-SCORE".underscore()
    # => "under_score"
    
    "UnDEr-SCorE".underscore()
    # => "un_d_er_s_cor_e"

@name underscore
@methodOf String#
@returns {String} A new string. Separated by _.
###
String::underscore = ->
  this.replace(/([A-Z]+)([A-Z][a-z])/g, '$1_$2')
    .replace(/([a-z\d])([A-Z])/g, '$1_$2')
    .replace(/-/g, '_')
    .toLowerCase()

###*
Assumes the string is something like a file name and returns the 
contents of the string without the extension.

    "neat.png".witouthExtension() 
    # => "neat"

@name withoutExtension
@methodOf String#
@returns {String} A new string without the extension name.
###
String::withoutExtension = ->
  this.replace(/\.[^\.]*$/, '')

String::parseHex = ->
  hexString = @replace(/#/, '')

  switch hexString.length
    when 3, 4
      if hexString.length == 4
        alpha = ((parseInt(hexString.substr(3, 1), 16) * 0x11) / 255)
      else
        alpha = 1

      rgb = (parseInt(hexString.substr(i, 1), 16) * 0x11 for i in [0..2])      
      rgb.push(alpha)    

      return rgb

    when 6, 8
      if hexString.length == 8
        alpha = (parseInt(hexString.substr(6, 2), 16) / 255)
      else
        alpha = 1

      rgb = (parseInt(hexString.substr(2 * i, 2), 16) for i in [0..2])          
      rgb.push(alpha)

      return rgb

    else
      return undefined

