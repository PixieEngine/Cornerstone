(

  window.QuadTree(I) ->
    I ||= {}
    
    $.reverseMerge I,
      bounds:
        x: 0
        y: 0
        width: 480
        height: 320
      maxDepth: 4
      maxChildren: 5
      
    root = Node(I.bounds, I.maxDepth, I.maxChildren()

    self =
      clear: ->
        root.clear()
    
      insert: (obj) ->
        if obj instanceOf Array
          obj.invoke('root.insert') 
        else
          root.insert(obj)
          
          
      retrieve: (item) ->
        return root.retrieve(item).copy()
        
 
    
    self

)()