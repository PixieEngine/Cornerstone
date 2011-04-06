((window) ->

  QuadTree = (I) ->
      I ||= {}
      
      $.reverseMerge I,
        bounds:
          x: 0
          y: 0
          width: 480
          height: 320
        maxDepth: 4
        maxChildren: 5
        
      root = Node(I.bounds, I.maxDepth, I.maxChildren)
  
      self =
        I: I
        root: -> root
      
        clear: -> root.clear()
      
        insert: (obj) ->
          if obj.isArray()
            obj.each (item) ->
              root.insert(item) 
          else
            root.insert(obj)
                
        retrieve: (item) -> root.retrieve(item).copy()
          
      self
      
    window.Node = (I) ->
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
        maxDepth: 4
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
        I: I
        
        clear: ->
          I.children.clear()
          
          I.nodes.invoke('clear')
          
          I.nodes.clear()
      
        insert: (item) ->
          index = findIndex(item)
         
          if I.nodes.length
            return I.nodes[index].insert(item)
            
          I.children.push(item)
          
          if (I.depth < I.maxDepth) && (I.children.length > I.maxChildren)
            self.subdivide()
            
            I.children.each (child) ->
              self.insert(child)
            
            I.children.clear()    
        
        retrieve: (item) ->
          if I.nodes.length
            index = findIndex(item)
      
            return I.nodes[index].retrieve(item)
        
          return I.children    
            
        subdivide: ->
          depth = I.depth + 1
      
          b_x = I.bounds.x
          b_y = I.bounds.y
          
          b_w_h = (I.bounds.width / 2).floor() 
          b_h_h = (I.bounds.height / 2).floor()
          bx_b_w_h = b_x + b_w_h
          by_b_h_h = b_y + b_h_h  
          
          I.nodes[TOP_LEFT] = Node
            bounds:
              x: b_x
              y: b_y
              width: b_w_h
              height: b_h_h
            depth: depth
            
          I.nodes[TOP_RIGHT] = Node
            bounds:
              x: bx_b_w_h
              y: b_y
              width: b_w_h
              height: b_h_h
            depth: depth
            
          I.nodes[BOTTOM_LEFT] = Node
            bounds:
              x: b_x
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
      
  window.QuadTree = QuadTree
)(window)