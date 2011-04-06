module "QuadTree"
 
test "should have bounds", ->
  quadTree = QuadTree()
    
  equals quadTree.I.bounds.x, 0
  equals quadTree.I.bounds.y, 0
  equals quadTree.I.bounds.width, 480
  equals quadTree.I.bounds.height, 320
  
  equals quadTree.root().I.bounds.width, 480, "root should have correct width"
  equals quadTree.root().I.bounds.height, 320, "root should have correct height"
  
test "should insert and retrieve point", ->
  quadTree = QuadTree()
   
  quadTree.insert
    x: 50
    y: 100
    
  items = quadTree.retrieve
    x: 50
    y: 100
    
  ok items.length
  
test "should subdivide if too many points are inserted", ->
  quadTree = QuadTree()
  
  (quadTree.I.maxChildren + 1).times ->
    quadTree.insert
      x: 2
      y: 5
              
  ok quadTree.root().I.nodes.length
  
test "points should end up in the correct nodes", ->
  quadTree = QuadTree()
  
  (quadTree.I.maxChildren + 1).times ->
    quadTree.insert
      x: 50
      y: 50
    
  ok quadTree.root().I.nodes[0].I.children.length == quadTree.I.maxChildren + 1
  
module()