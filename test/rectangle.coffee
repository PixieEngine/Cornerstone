module "Rectangle"

test "getter for left calculates correctly", ->
  rect = Rectangle
    x: 2
    y: 30
    width: 2
    height: 49

  equals rect.left, 2

test "getter for right calculates correctly", ->
  rect = Rectangle
    x: 10
    y: 15
    width: 5
    height: 20

  equals rect.right, 15

test "getter for top calculates correctly", ->
  rect = Rectangle
    x: 3
    y: 4
    width: 5
    height: 6

  equals rect.top, 4

test "getter for bottom calculates correctly", ->
  rect = Rectangle
    x: 20
    y: 5
    width: 25
    height: 30

  equals rect.bottom, 35

test "#center", ->
  rect = Rectangle
    x: 23
    y: 21
    width: 10
    height: 4

  ok rect.center().equal(Point(28, 23))

test "#equal", ->
  rect1 = Rectangle
    x: 9
    y: 3
    width: 7
    height: 4

  rect2 = Rectangle
    x: 4
    y: 3
    width: 8
    height: 2

  rect3 = Rectangle
    x: 9
    y: 3
    width: 7
    height: 4

  ok !rect1.equal(rect2)
  ok rect1.equal(rect3)

module()
