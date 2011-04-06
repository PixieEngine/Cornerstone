module "QuadTree"
 
test "should have bounds", ->
  quadTree = QuadTree()
    
  equals quadTree.I.bounds.x, 0
  equals quadTree.I.bounds.y, 0
  equals quadTree.I.bounds.width, 480
  equals quadTree.I.bounds.height, 320
  
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
  
  (quadTree.I.maxChildren + 1).times (n) ->
    quadTree.insert
      x: 2
      y: 5
              
  ok quadTree.root().I.nodes.length
  
module()