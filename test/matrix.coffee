( ->
  module "Matrix"

  TOLERANCE = 0.00001

  equalEnough = (expected, actual, tolerance, message) ->
    message ||= "" + expected + " within " + tolerance + " of " + actual
    ok(expected + tolerance >= actual && expected - tolerance <= actual, message)

  matrixEqual = (m1, m2) ->
    equalEnough(m1.a, m2.a, TOLERANCE)
    equalEnough(m1.b, m2.b, TOLERANCE)
    equalEnough(m1.c, m2.c, TOLERANCE)
    equalEnough(m1.d, m2.d, TOLERANCE)
    equalEnough(m1.tx, m2.tx, TOLERANCE)
    equalEnough(m1.ty, m2.ty, TOLERANCE)

  test "Matrix() (Identity)", ->
    matrix = Matrix()

    equals(matrix.a, 1, "a")
    equals(matrix.b, 0, "b")
    equals(matrix.c, 0, "c")
    equals(matrix.d, 1, "d")
    equals(matrix.tx, 0, "tx")
    equals(matrix.ty, 0, "ty")

    matrixEqual(matrix, Matrix.IDENTITY)

  test "Empty", ->
    matrix = Matrix(0, 0, 0, 0, 0, 0)

    equals(matrix.a, 0, "a")
    equals(matrix.b, 0, "b")
    equals(matrix.c, 0, "c")
    equals(matrix.d, 0, "d")
    equals(matrix.tx, 0, "tx")
    equals(matrix.ty, 0, "ty")

  test "#copy", ->
    matrix = Matrix(2, 0, 0, 2)

    copyMatrix = matrix.copy()

    matrixEqual copyMatrix, matrix

    copyMatrix.a = 4

    equals copyMatrix.a, 4
    equals matrix.a, 2, "Old 'a' value is unchanged"

  test ".scale", ->
    matrix = Matrix.scale(2, 2)

    equals(matrix.a, 2, "a")
    equals(matrix.b, 0, "b")
    equals(matrix.c, 0, "c")
    equals(matrix.d, 2, "d")

    matrix = Matrix.scale(3)

    equals(matrix.a, 3, "a")
    equals(matrix.b, 0, "b")
    equals(matrix.c, 0, "c")
    equals(matrix.d, 3, "d")

  test ".scale (about a point)", ->
    p = Point(5, 17)

    transformedPoint = Matrix.scale(3, 7, p).transformPoint(p)

    equals(transformedPoint.x, p.x, "Point should remain the same")
    equals(transformedPoint.y, p.y, "Point should remain the same")

  test "#scale (about a point)", ->
    p = Point(3, 11)

    transformedPoint = Matrix.IDENTITY.scale(3, 7, p).transformPoint(p)

    equals(transformedPoint.x, p.x, "Point should remain the same")
    equals(transformedPoint.y, p.y, "Point should remain the same")

  test "#skew", ->
    matrix = Matrix()
    matrix.skew(0.125.turns, 0)
    
  test ".rotation", ->
    matrix = Matrix.rotation(Math.PI / 2)

    equalEnough(matrix.a, 0, TOLERANCE)
    equalEnough(matrix.b, 1, TOLERANCE)
    equalEnough(matrix.c,-1, TOLERANCE)
    equalEnough(matrix.d, 0, TOLERANCE)

  test ".rotation (about a point)", ->
    p = Point(11, 7)

    transformedPoint = Matrix.rotation(Math.PI / 2, p).transformPoint(p)

    equals transformedPoint.x, p.x, "Point should remain the same"
    equals transformedPoint.y, p.y, "Point should remain the same"

  test "#rotate (about a point)", ->
    p = Point(8, 5);

    transformedPoint = Matrix.IDENTITY.rotate(Math.PI / 2, p).transformPoint(p)

    equals transformedPoint.x, p.x, "Point should remain the same"
    equals transformedPoint.y, p.y, "Point should remain the same"

  test "#inverse (Identity)", ->
    matrix = Matrix().inverse()

    equals(matrix.a, 1, "a")
    equals(matrix.b, 0, "b")
    equals(matrix.c, 0, "c")
    equals(matrix.d, 1, "d")
    equals(matrix.tx, 0, "tx")
    equals(matrix.ty, 0, "ty")

  test "#concat", ->
    matrix = Matrix.rotation(Math.PI / 2).concat(Matrix.rotation(-Math.PI / 2))

    matrixEqual(matrix, Matrix.IDENTITY)

  test "#toString", ->
    matrix = Matrix(0.5, 2, 0.5, -2, 3, 4.5)
    matrixEqual eval(matrix.toString()), matrix

  test "Maths", ->
    a = Matrix(12, 3, 3, 1, 7, 9)
    b = Matrix(3, 8, 3, 2, 1, 5)

    c = a.concat(b)

    equals(c.a, 60)
    equals(c.b, 17)
    equals(c.c, 42)
    equals(c.d, 11)
    equals(c.tx, 34)
    equals(c.ty, 17)

  test "Order of transformations should match manual concat", ->
    tx = 10
    ty = 5
    theta = Math.PI/3
    s = 2

    m1 = Matrix().translate(tx, ty).scale(s).rotate(theta)
    m2 = Matrix().concat(Matrix.translation(tx, ty)).concat(Matrix.scale(s)).concat(Matrix.rotation(theta))

    matrixEqual(m1, m2)

  test "IDENTITY is immutable", ->
    identity = Matrix.IDENTITY

    identity.a = 5

    equals identity.a, 1

  module undefined
)()

