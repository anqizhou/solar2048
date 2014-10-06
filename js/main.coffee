

randomInt = (n) ->
# n is defined so that the function gives a random integer between 0 and n-1.
  Math.floor(Math.random() * n)
#------ Defining low level functions that we'd use later on ------

randomCellIndices = ->
  [randomInt(4), randomInt(4)]


randomValue = ->
  values = [2, 2, 2, 4]
  values[randomInt(4)]




#------ Defining actions ------


buildBoard = ->
  board = [0..3].map(-> [0..3].map(-> 0))


generateTile = (board) ->
  console.log "Generating a tile."
  [row, column] = randomCellIndices()
  console.log "row: #{row} / column #{column}"
  value = randomValue()

  if board[row][column] == 0
    board[row][column] = value
  else
    generateTile(board)


printArray = (array) ->
  console.log "--START--"
  # Print every row in the array
  console.log row for row in array
  console.log "--END--"


showBoard = (board) ->
  for row in [0..3]
    for col in [0..3]
      for powerNum in [1..11]
        $(".r#{row}.c#{col} > div").removeClass("val-#{2**powerNum}")
      if board[row][col] == 0
        $(".r#{row}.c#{col} > div").html('')
      else
        $(".r#{row}.c#{col} > div").html(board[row][col])
        $(".r#{row}.c#{col} > div").addClass("val-#{board[row][col]}")


move = (board, direction) ->
  newBoard = buildBoard()
  if direction is "right" or direction is "left"
    for i in [0..3]
        row = getRow(i, board)
        mergeCells(row, direction)
        newRow = collapseCells(row, direction)
        setRow(newRow, i, newBoard)
    console.log "Showing new board:", newBoard
    newBoard

  else if direction is "up"
    transposedBackBoard = buildBoard()
    newDirection = "left"
    transposedBoard = transpose(board)
    for i in [0..3]
      row = getRow(i, transposedBoard)
      mergeCells(row, newDirection)
      newRow = collapseCells(row, newDirection)
      setRow(newRow, i, newBoard)
    transposedBackBoard = transpose(newBoard)
    console.log "Showing transposed * 2 new board:", transposedBackBoard
    transposedBackBoard

  else if direction is "down"
    transposedBackBoard = buildBoard()
    newDirection = "right"
    transposedBoard = transpose(board)
    for i in [0..3]
      row = getRow(i, transposedBoard)
      mergeCells(row, newDirection)
      newRow = collapseCells(row, newDirection)
      setRow(newRow, i, newBoard)
    transposedBackBoard = transpose(newBoard)
    console.log "Showing transposed * 2 new board:", transposedBackBoard
    transposedBackBoard


# console.log move([[1, 1, 1, 1], [2, 2, 2, 2], [3, 3, 3, 3], [4, 4, 4, 4]], "down")

getRow = (r, board) ->
  console.log "Getting the Row"
  row = [board[r][0], board[r][1], board[r][2], board[r][3]]

setRow = (row, index, board) ->
  board[index] = row


mergeCells = (row, direction) -> #the row should be using the cloned version
  merge = (row) ->
    for a in [3..1]
      for b in [a-1..0]
        if row[a] == 0 then break
        else if row[a] == row[b]
          row[a] *= 2
          row[b] = 0
          break
        else if row[b] != 0 then break
    row

  if direction == "right"
    merge(row)

  if direction == "left"
    merge(row.reverse()).reverse()


collapseCells = (row, direction) ->
  switch direction
    when 'right'
      # Remove 0
      newRow = row.filter (x) -> x > 0
      while newRow.length < 4
        newRow.unshift(0)
      newRow
    when 'left'
      newRow = row.filter (x) -> x > 0
      while newRow.length < 4
        newRow.push(0)
      newRow

moveIsValid = (oriBoard, newBoard) ->
  for row in [0..3]
    for col in [0..3]
      if oriBoard[row][col] isnt newBoard[row][col]
        return true
  false

isGameOver = (board) ->
  boardIsFull(board) and noValidMove(board)


boardIsFull = (board) ->
  for row in board
    if 0 in row
      return false
  console.log "Board is fullllllll"
  true


noValidMove = (board) ->
  for direction in ['left', 'right', 'up', 'down'] # skipped "up" and "down"
    newBoard = move(board, direction)
    if moveIsValid(board, newBoard)
      return false
  true

transpose = (board) ->
  newBoard = buildBoard()
  for row in [0..3]
    for col in [-0..3]
      value = board[row][col]
      newBoard[col][row] = value
  newBoard


# Check if transpose works
# console.log transpose([[1, 1, 1, 1], [2, 2, 2, 2], [3, 3, 3, 3], [4, 4, 4, 4]])


$ ->
  @board = buildBoard()
  generateTile(@board)
  generateTile(@board)
  printArray(@board)
  showBoard(@board)


  $('body').keydown (event) =>
    key = event.which
    keys = [37..40]
    if key in keys
      event.preventDefault()
      #continue game
      direction = switch key
        when 37 then "left"
        when 38 then "up"
        when 39 then "right"
        when 40 then "down"

      console.log "Direction is", direction


      #moving
      newBoard = move(@board, direction)
      printArray newBoard

      #Check if move is valid
      if moveIsValid(@board, newBoard)
        console.log "valid"
        @board = newBoard
        #Generate new tile
        generateTile(@board)
        showBoard(@board)
        #Show new board on the screen
        #Check Game lost

      else
        console.log "invalid"
        if isGameOver(@board)
          console.log "You Lose!"




      # check moving validily
    else
      #do nothing

