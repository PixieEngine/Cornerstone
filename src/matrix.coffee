###*
* Matrix.js v1.3.0pre
* 
* Copyright (c) 2010 STRd6
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*
* Loosely based on flash:
* http://www.adobe.com/livedocs/flash/9.0/ActionScriptLangRefV3/flash/geom/Matrix.html
###
( ->
  ###*
  <pre>
     _        _
    | a  c tx  |
    | b  d ty  |
    |_0  0  1 _|
  </pre>
  Creates a matrix for 2d affine transformations.

  concat, inverse, rotate, scale and translate return new matrices with the
  transformations applied. The matrix is not modified in place.

  Returns the identity matrix when called with no arguments.

  @name Matrix
  @param {Number} [a]
  @param {Number} [b]
  @param {Number} [c]
  @param {Number} [d]
  @param {Number} [tx]
  @param {Number} [ty]
  @constructor
  ###
  Matrix = (a, b, c, d, tx, ty) ->
    __proto__: Matrix::
    ###*
    @name a
    @fieldOf Matrix#
    ###
    a: if a? then a else 1

    ###*
    @name b
    @fieldOf Matrix#
    ###
    b: b || 0

    ###*
    @name c
    @fieldOf Matrix#
    ###
    c: c || 0,

    ###*
    @name d
    @fieldOf Matrix#
    ###
    d: if d? then d else 1

    ###*
    @name tx
    @fieldOf Matrix#
    ###
    tx: tx || 0

    ###*
    @name ty
    @fieldOf Matrix#
    ###
    ty: ty || 0

  Matrix:: =
    ###*
    Returns the result of this matrix multiplied by another matrix
    combining the geometric effects of the two. In mathematical terms, 
    concatenating two matrixes is the same as combining them using matrix multiplication.
    If this matrix is A and the matrix passed in is B, the resulting matrix is A x B
    http://mathworld.wolfram.com/MatrixMultiplication.html
    @name concat
    @methodOf Matrix#

    @param {Matrix} matrix The matrix to multiply this matrix by.
    @returns The result of the matrix multiplication, a new matrix.
    @type Matrix
    ###
    concat: (matrix) ->
      Matrix(
        this.a * matrix.a + this.c * matrix.b,
        this.b * matrix.a + this.d * matrix.b,
        this.a * matrix.c + this.c * matrix.d,
        this.b * matrix.c + this.d * matrix.d,
        this.a * matrix.tx + this.c * matrix.ty + this.tx,
        this.b * matrix.tx + this.d * matrix.ty + this.ty
      )

    ###*
    Given a point in the pretransform coordinate space, returns the coordinates of 
    that point after the transformation occurs. Unlike the standard transformation 
    applied using the transformPoint() method, the deltaTransformPoint() method 
    does not consider the translation parameters tx and ty.
    @name deltaTransformPoint
    @methodOf Matrix#
    @see #transformPoint

    @return A new point transformed by this matrix ignoring tx and ty.
    @type Point
    ###
    deltaTransformPoint: (point) ->
      Point(
        this.a * point.x + this.c * point.y,
        this.b * point.x + this.d * point.y
      )

    ###*
    Returns the inverse of the matrix.
    http://mathworld.wolfram.com/MatrixInverse.html
    @name inverse
    @methodOf Matrix#

    @returns A new matrix that is the inverse of this matrix.
    @type Matrix
    ###
    inverse: ->
      determinant = this.a * this.d - this.b * this.c

      Matrix(
        this.d / determinant,
        -this.b / determinant,
        -this.c / determinant,
        this.a / determinant,
        (this.c * this.ty - this.d * this.tx) / determinant,
        (this.b * this.tx - this.a * this.ty) / determinant
      )

    ###*
    Returns a new matrix that corresponds this matrix multiplied by a
    a rotation matrix.
    @name rotate
    @methodOf Matrix#
    @see Matrix.rotation

    @param {Number} theta Amount to rotate in radians.
    @param {Point} [aboutPoint] The point about which this rotation occurs. Defaults to (0,0).
    @returns A new matrix, rotated by the specified amount.
    @type Matrix
    ###
    rotate: (theta, aboutPoint) ->
      this.concat(Matrix.rotation(theta, aboutPoint))

    ###*
    Returns a new matrix that corresponds this matrix multiplied by a
    a scaling matrix.
    @name scale
    @methodOf Matrix#
    @see Matrix.scale

    @param {Number} sx
    @param {Number} [sy]
    @param {Point} [aboutPoint] The point that remains fixed during the scaling
    @type Matrix
    ###
    scale: (sx, sy, aboutPoint) ->
      this.concat(Matrix.scale(sx, sy, aboutPoint))

    ###*
    Returns the result of applying the geometric transformation represented by the 
    Matrix object to the specified point.
    @name transformPoint
    @methodOf Matrix#
    @see #deltaTransformPoint

    @returns A new point with the transformation applied.
    @type Point
    ###
    transformPoint: (point) ->
      Point(
        this.a * point.x + this.c * point.y + this.tx,
        this.b * point.x + this.d * point.y + this.ty
      )

    ###*
    Translates the matrix along the x and y axes, as specified by the tx and ty parameters.
    @name translate
    @methodOf Matrix#
    @see Matrix.translation

    @param {Number} tx The translation along the x axis.
    @param {Number} ty The translation along the y axis.
    @returns A new matrix with the translation applied.
    @type Matrix
    ###
    translate: (tx, ty) ->
      this.concat(Matrix.translation(tx, ty))


  ###*
  Creates a matrix transformation that corresponds to the given rotation,
  around (0,0) or the specified point.
  @see Matrix#rotate

  @param {Number} theta Rotation in radians.
  @param {Point} [aboutPoint] The point about which this rotation occurs. Defaults to (0,0).
  @returns 
  @type Matrix
  ###
  Matrix.rotate = Matrix.rotation = (theta, aboutPoint) ->
    rotationMatrix = Matrix(
      Math.cos(theta),
      Math.sin(theta),
      -Math.sin(theta),
      Math.cos(theta)
    )

    if aboutPoint?
      rotationMatrix =
        Matrix.translation(aboutPoint.x, aboutPoint.y).concat(
          rotationMatrix
        ).concat(
          Matrix.translation(-aboutPoint.x, -aboutPoint.y)
        )

    return rotationMatrix

  ###*
  Returns a matrix that corresponds to scaling by factors of sx, sy along
  the x and y axis respectively.
  If only one parameter is given the matrix is scaled uniformly along both axis.
  If the optional aboutPoint parameter is given the scaling takes place
  about the given point.
  @see Matrix#scale

  @param {Number} sx The amount to scale by along the x axis or uniformly if no sy is given.
  @param {Number} [sy] The amount to scale by along the y axis.
  @param {Point} [aboutPoint] The point about which the scaling occurs. Defaults to (0,0).
  @returns A matrix transformation representing scaling by sx and sy.
  @type Matrix
  ###
  Matrix.scale = (sx, sy, aboutPoint) ->
    sy = sy || sx

    scaleMatrix = Matrix(sx, 0, 0, sy)

    if aboutPoint
      scaleMatrix =
        Matrix.translation(aboutPoint.x, aboutPoint.y).concat(
          scaleMatrix
        ).concat(
          Matrix.translation(-aboutPoint.x, -aboutPoint.y)
        )

    return scaleMatrix

  ###*
  Returns a matrix that corresponds to a translation of tx, ty.
  @see Matrix#translate

  @param {Number} tx The amount to translate in the x direction.
  @param {Number} ty The amount to translate in the y direction.
  @return A matrix transformation representing a translation by tx and ty.
  @type Matrix
  ###
  Matrix.translate = Matrix.translation = (tx, ty) ->
    Matrix(1, 0, 0, 1, tx, ty)

  ###*
  A constant representing the identity matrix.
  @name IDENTITY
  @fieldOf Matrix
  ###
  Matrix.IDENTITY = Matrix()

  ###*
  A constant representing the horizontal flip transformation matrix.
  @name HORIZONTAL_FLIP
  @fieldOf Matrix
  ###
  Matrix.HORIZONTAL_FLIP = Matrix(-1, 0, 0, 1)

  ###*
  A constant representing the vertical flip transformation matrix.
  @name VERTICAL_FLIP
  @fieldOf Matrix
  ###
  Matrix.VERTICAL_FLIP = Matrix(1, 0, 0, -1)

  # Export to window
  window["Point"] = $.noop #TODO: Figure out why things barf without this line
  window["Matrix"] = Matrix
)()

