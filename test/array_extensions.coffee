test "Array#copy", ->
  a = [1,2,3]
  b = a.copy()
  
  ok a != b, "Original array is not the same array as the copied one"
  ok a.length == b.length, "Both arrays are the same size"
  ok a[0] == b[0] && a[1] == b[1] && a[2] == b[2], "The elements of the two arrays are equal"

test "Array#rand", ->
  array = [1,2,3]
  
  ok array.indexOf(array.rand()) != -1, "Array includes randomly selected element"
  ok [5].rand() == 5, "[5].rand() === 5"
  ok [].rand() == undefined, "[].rand() === undefined"

test "Array#remove", ->
  equals [1,2,3].remove(2), 2, "[1,2,3].remove(2) === 2"
  equals [1,3].remove(2), undefined, "[1,3].remove(2) === undefined"
  equals [1,3].remove(3), 3, "[1,3].remove(3) === 3"
  
  array = [1,2,3]
  array.remove(2)
  ok array.length == 2, "array = [1,2,3]; array.remove(2); array.length === 2"
  array.remove(3)
  ok array.length == 1, "array = [1,3]; array.remove(3); array.length === 1"

test "Array#map", ->
  equals [1].map((x) -> return x + 1 )[0], 2

test "Array#each", ->
  array = [1, 2, 3]
  count = 0

  equals array, array.each -> count++
  equals array.length, count
         
test "Array#shuffle", ->
  array = [0, 1, 2, 3, 4, 5]

  shuffledArray = array.shuffle()

  shuffledArray.each (element) ->
    ok array.indexOf(element) >= 0, "Every element in shuffled array is in orig array"

  array.each (element) ->
    ok shuffledArray.indexOf(element) >= 0, "Every element in orig array is in shuffled array"

test "Array#first", ->
  equals [2].first(), 2
  equals [1, 2, 3].first(), 1
  equals [].first(), undefined

test "Array#last", ->
  equals [2].last(), 2
  equals [1, 2, 3].last(), 3
  equals [].first(), undefined

test "Array#sum", ->
  equals [].sum(), 0, "Empty array sums to zero"
  equals [2].sum(), 2, "[2] sums to 2"
  equals [1, 2, 3, 4, 5].sum(), 15, "[1, 2, 3, 4, 5] sums to 15"

test "Array#eachSlice", 6, ->
  [1, 2, 3, 4, 5, 6].eachSlice 2, (array) ->
    equals array[0] % 2, 1
    equals array[1] % 2, 0

test "Array#without", ->
  array = [1, 2, 3, 4]
  
  excluded = array.without([2, 4])
  
  equals excluded[0], 1
  equals excluded[1], 3

test "Array#clear", ->
  array = [1, 2, 3, 4]

  equals array.length, 4
  equals array[0], 1
  
  array.clear()
    
  equals array.length, 0
  equals array[0], undefined

test "Array#wrap", ->
  array = [0, 1, 2, 3, 4]

  equals array.wrap(0), 0
  equals array.wrap(-1), 4
  equals array.wrap(2), 2

