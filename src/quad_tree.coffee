(
  window.QuadTree = (I) ->
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
      clear: ->
        I.children.clear()
        
        I.nodes.each (node) ->
          node.clear()
        
        I.nodes.clear()
    
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
          
      subdivide: ->
        depth = I.depth + 1
    
        bx = I.bounds.x
        by = I.bounds.y
        
        b_w_h = (I.bounds.width / 2).floor() 
        b_h_h = (I.bounds.height / 2).floor()
        bx_b_w_h = bx + b_w_h
        by_b_h_h = by + b_h_h  
        
        I.nodes[TOP_LEFT] = Node
          bounds:
            x: bx
            y: by
            width: b_w_h
            height: b_h_h
          depth: depth
          
        I.nodes[TOP_RIGHT] = Node
          bounds:
            x: bx_b_w_h
            y: by
            width: b_w_h
            height: b_h_h
          depth: depth
          
        I.nodes[BOTTOM_LEFT] = Node
          bounds:
            x: bx
            y: by_b_h_h
            width: b_w_h
            height: b_h_h
          depth: depth
          
        I.nodes[BOTTOM_RIGHT] = Node
          bounds:
            x: bx_b_w_h
            y: by_b_h_h
            width: b_w_h
            height: b_h_h
          depth: depth
    
    self

)()