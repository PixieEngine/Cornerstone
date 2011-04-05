module "QuadTree"
 
test "should have bounds", ->
  quadTree = QuadTree()
  
  log quadTree
  
  equals quadTree.I.bounds.x, 0
  equals quadTree.I.bounds.y, 0
  equals quadTree.I.bounds.width, 480
  equals quadTree.I.bounds.height, 320
