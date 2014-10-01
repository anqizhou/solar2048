
buildBoard = ->
  console.log "Building a board."

  board = []

  for row in [0..3]
    board[row] = []
    for column in [0..3]
      board[row][column] = -1

  board


generateTile = ->
  console.log "Generating a tile."


printArray = (array) ->
  console.log "--START--"
  # Print every row in the array
  for row in array
    console.log row
  console.log "--END--"



$ ->
  newBoard = buildBoard()
  printArray (newBoard)
  generateTile()
  generateTile()


