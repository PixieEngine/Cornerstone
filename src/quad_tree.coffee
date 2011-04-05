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
    
  window.Node(I) ->
    I ||= {}
    
    $.reverseMerge I,
      bounds: 
        x: 0
        y: 0
        width: 120
        height: 80
      children: []
      depth: 0
      maxChildren: 5
      nodes: []
      
    TOP_LEFT = 0
    TOP_RIGHT = 1
    BOTTOM_LEFT = 2
    BOTTOM_RIGHT = 3
      
    findIndex = (item) ->
      bounds = I.bounds
      left = (if (item.x > bounds.x + bounds.width / 2) then false else true)
      top = (if (item.y > bounds.y + bounds.height / 2) then false else true)
      
      index = TOP_LEFT
      
      if left
        if !top
          index = BOTTOM_LEFT
      else
        if top
          index = TOP_RIGHT
        else
          index = BOTTOM_RIGHT
      
      return index
      
    self =
    
      insert: (item) ->
        index = findIndex(item)
       
        if I.nodes.length
          return I.nodes[index]insert(item)
          
        I.children.push(item)
        
        if (I.depth >= I.maxDepth) && (I.children.length > I.maxChildren)
          self.subdivide()
          
          I.children.invoke('self.insert')
          
          I.children.clear()    
      
      retrieve: (item) ->
        if I.nodes.length
          index = findIndex(item)
    
          return I.nodes[index].retrieve(item)
      
        return I.children    
          
          
      
    
    self

)()