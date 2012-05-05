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
    @returns {Matrix} The result of the matrix multiplication, a new matrix.
    ###
    concat: (matrix) ->
      Matrix(
        @a * matrix.a + @c * matrix.b,
        @b * matrix.a + @d * matrix.b,
        @a * matrix.c + @c * matrix.d,
        @b * matrix.c + @d * matrix.d,
        @a * matrix.tx + @c * matrix.ty + @tx,
        @b * matrix.tx + @d * matrix.ty + @ty
      )

    ###*
    Copy this matrix.
    @name copy
    @methodOf Matrix#
    @returns {Matrix} A copy of this matrix.
    ###
    copy: ->
      Matrix(@a, @b, @c, @d, @tx, @ty)

    ###*
    Given a point in the pretransform coordinate space, returns the coordinates of 
    that point after the transformation occurs. Unlike the standard transformation 
    applied using the transformPoint() method, the deltaTransformPoint() method 
    does not consider the translation parameters tx and ty.
    @name deltaTransformPoint
    @methodOf Matrix#
    @see #transformPoint
    @return {Point} A new point transformed by this matrix ignoring tx and ty.
    ###
    deltaTransformPoint: (point) ->
      Point(
        @a * point.x + @c * point.y,
        @b * point.x + @d * point.y
      )

    ###*
    Returns the inverse of the matrix.
    http://mathworld.wolfram.com/MatrixInverse.html
    @name inverse
    @methodOf Matrix#
    @returns {Matrix} A new matrix that is the inverse of this matrix.
    ###
    inverse: ->
      determinant = @a * @d - @b * @c

      Matrix(
        @d / determinant,
        -@b / determinant,
        -@c / determinant,
        @a / determinant,
        (@c * @ty - @d * @tx) / determinant,
        (@b * @tx - @a * @ty) / determinant
      )

    ###*
    Returns a new matrix that corresponds this matrix multiplied by a
    a rotation matrix.
    @name rotate
    @methodOf Matrix#
    @see Matrix.rotation
    @param {Number} theta Amount to rotate in radians.
    @param {Point} [aboutPoint] The point about which this rotation occurs. Defaults to (0,0).
    @returns {Matrix} A new matrix, rotated by the specified amount.
    ###
    rotate: (theta, aboutPoint) ->
      @concat(Matrix.rotation(theta, aboutPoint))

    ###*
    Returns a new matrix that corresponds this matrix multiplied by a
    a scaling matrix.
    @name scale
    @methodOf Matrix#
    @see Matrix.scale
    @param {Number} sx
    @param {Number} [sy]
    @param {Point} [aboutPoint] The point that remains fixed during the scaling
    @returns {Matrix} A new Matrix. The original multiplied by a scaling matrix.
    ###
    scale: (sx, sy, aboutPoint) ->
      @concat(Matrix.scale(sx, sy, aboutPoint))
      
    skew: () ->

    ###*
    Returns a string representation of this matrix.

    @name toString
    @methodOf Matrix#
    @returns {String} A string reperesentation of this matrix.
    ###
    toString: ->
      "Matrix(#{@a}, #{@b}, #{@c}, #{@d}, #{@tx}, #{@ty})"

    ###*
    Returns the result of applying the geometric transformation represented by the 
    Matrix object to the specified point.
    @name transformPoint
    @methodOf Matrix#
    @see #deltaTransformPoint
    @returns {Point} A new point with the transformation applied.
    ###
    transformPoint: (point) ->
      Point(
        @a * point.x + @c * point.y + @tx,
        @b * point.x + @d * point.y + @ty
      )

    ###*
    Translates the matrix along the x and y axes, as specified by the tx and ty parameters.
    @name translate
    @methodOf Matrix#
    @see Matrix.translation
    @param {Number} tx The translation along the x axis.
    @param {Number} ty The translation along the y axis.
    @returns {Matrix} A new matrix with the translation applied.
    ###
    translate: (tx, ty) ->
      @concat(Matrix.translation(tx, ty))

  ###*
  Creates a matrix transformation that corresponds to the given rotation,
  around (0,0) or the specified point.
  @see Matrix#rotate
  @param {Number} theta Rotation in radians.
  @param {Point} [aboutPoint] The point about which this rotation occurs. Defaults to (0,0).
  @returns {Matrix} A new matrix rotated by the given amount.
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
  @returns {Matrix} A matrix transformation representing scaling by sx and sy.
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
  Returns a matrix that corresponds to a skew of skewX, skewY.

  @see Matrix#skew
  @param {Number} skewX The angle of skew in the x dimension.
  @param {Number} skewY The angle of skew in the y dimension.
  @return {Matrix} A matrix transformation representing a skew by skewX and skewY.
  ###
  Matrix.skew = (skewX, skewY) ->
    Matrix(0, Math.tan(skewY), Math.tan(skewX), 0)

  ###*
  Returns a matrix that corresponds to a translation of tx, ty.
  @see Matrix#translate
  @param {Number} tx The amount to translate in the x direction.
  @param {Number} ty The amount to translate in the y direction.
  @return {Matrix} A matrix transformation representing a translation by tx and ty.
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

  if Object.freeze
    Object.freeze Matrix.IDENTITY
    Object.freeze Matrix.HORIZONTAL_FLIP
    Object.freeze Matrix.VERTICAL_FLIP

  # Export to window
  (exports ? this)["Matrix"] = Matrix
)()

