( ->
  ###*
  @name Local
  @namespace
  ###

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

  # Export
  (exports ? this)["Local"] =
    get: retrieve
    set: store
    put: store
    ###*
    Access an instance of Local with a specified prefix.

    @name new
    @methodOf Local

    @param {String} prefix
    @type Local
    @returns An interface to local storage with the given prefix applied.
    ###
    new: (prefix) ->
      prefix ||= ""

      get: (key) ->
        retrieve("#{prefix}_key")
      set: (key, value) ->
        store("#{prefix}_key", value)
      put: (key, value) ->
        store("#{prefix}_key", value)

)()

