( ($) ->
  ###*
  Store an object in local storage.

  @name set
  @methodOf Local

  @param {String} key
  @param {Object} value
  @type Object
  @returns value
  ###
  store = (key, value) ->
    localStorage[key] = JSON.stringify(value)

    return value

  ###*
  Retrieve an object from local storage.

  @name get
  @methodOf Local

  @param {String} key
  @type Object
  @returns The object that was stored or undefined if no object was stored.
  ###
  retrieve = (key) ->
    value = localStorage[key]

    if value?
      JSON.parse(value)
 
  window.Local = $.extend window.Local,
    get: retrieve
    set: store
    put: store
)(jQuery)

