extends Node
onready var colorBoard = $MarginContainer/VBoxContainer/BoardContainer/colorBoard
onready var board = $MarginContainer/VBoxContainer/BoardContainer/Board
#onready var turnDisplay = $TurnDisplay
onready var winDisplay = $MarginContainer/VBoxContainer/Container2/WinnerDisplay

onready var promoteWhite = $whitePromotion
onready var promoteBlack = $blackPromotion

var shader = preload("res://Assets/Shaders/outline.shader")
var wp = preload("res://Assets/Pieces White/white_pawn.png")
var wr = preload("res://Assets/Pieces White/white_rook.png")
var wn = preload("res://Assets/Pieces White/white_knight.png")
var wb = preload("res://Assets/Pieces White/white_bishop.png")
var wq = preload("res://Assets/Pieces White/white_queen.png")
var wk = preload("res://Assets/Pieces White/white_king.png")
var bp = preload("res://Assets/Pieces Black/black_pawn.png")
var br = preload("res://Assets/Pieces Black/black_rook.png")
var bn = preload("res://Assets/Pieces Black/black_knight.png")
var bb = preload("res://Assets/Pieces Black/black_bishop.png")
var bq = preload("res://Assets/Pieces Black/black_queen.png")
var bk = preload("res://Assets/Pieces Black/black_king.png")

var wpf = preload("res://Assets/Pieces White Flipped/white_pawn_flipped.png")
var wrf = preload("res://Assets/Pieces White Flipped/white_rook_flipped.png")
var wnf = preload("res://Assets/Pieces White Flipped/white_knight_flipped.png")
var wbf = preload("res://Assets/Pieces White Flipped/white_bishop_flipped.png")
var wqf = preload("res://Assets/Pieces White Flipped/white_queen_flipped.png")
var wkf = preload("res://Assets/Pieces White Flipped/white_king_flipped.png")
var bpf = preload("res://Assets/Pieces Black Flipped/black_pawn_flipped.png")
var brf = preload("res://Assets/Pieces Black Flipped/black_rook_flipped.png")
var bnf = preload("res://Assets/Pieces Black Flipped/black_knight_flipped.png")
var bbf = preload("res://Assets/Pieces Black Flipped/black_bishop_flipped.png")
var bqf = preload("res://Assets/Pieces Black Flipped/black_queen_flipped.png")
var bkf = preload("res://Assets/Pieces Black Flipped/black_king_flipped.png")

var texture = preload("res://Assets/Pieces Black/black_bishop.png")
var texture2 = preload("res://Assets/Pieces Black/black_king.png")
var buttonTiles = []
var selectedPiece = -1
var startingPositions = globvar.startPos
var outline = globvar.outline
var last_i = 0
var last_j = 0
var turn: bool = 1
var enPassantWhite = [0, 0, 0, 0, 0, 0, 0, 0]
var enPassantBlack= [0, 0, 0, 0, 0, 0, 0, 0]
var whiteCastleRight = 1
var whiteCastleLeft = 1
var blackCastleRight = 1
var blackCastleLeft = 1
var promotePawni = 0
var promotePawnj = 0
#var whiteHasKing = 1
#var blackHasKing = 1

var texture_dict = {
	0: null,
	1: wp,
	2: wr,
	3: wn,
	4: wb,
	5: wq,
	6: wk,
	7: bp,
	8: br,
	9: bn,
	10: bb,
	11: bq,
	12: bk
}
var texture_dict_flipped = {
	0: null,
	1: wpf,
	2: wrf,
	3: wnf,
	4: wbf,
	5: wqf,
	6: wkf,
	7: bpf,
	8: brf,
	9: bnf,
	10: bbf,
	11: bqf,
	12: bkf
}

var x = 0

#this creates the array and gives it starting values of 0
var boardArray = []
func createArray():
	for i in range(8):
#		boardArray.append([]) does the same thing but too goofy for me
		boardArray.append(Array())
		boardArray.back().resize(8)
		boardArray.back().fill(0)

#this creates the color part of the board
func boardColor():
	for j in range (0, 8):
		for i in range (0, 8):
			var tile = ColorRect.new()
			tile.size_flags_horizontal = ColorRect.SIZE_EXPAND_FILL
			tile.size_flags_vertical = ColorRect.SIZE_EXPAND_FILL
			if((i+j)%2 == 0):
				tile.color = Color(globvar.white)
			else:
				tile.color = Color(globvar.black)
			colorBoard.add_child(tile)

#this highlights the piece when it's selected


#this creates the buttons you use to interact with the board
func boardFunction():
	for j in range (1, 9):
		for i in range (1, 9):
			var buttonTile = TextureButton.new()
			buttonTile.connect("button_up", self, "_button_up", [j, i])
			buttonTile.size_flags_horizontal = ColorRect.SIZE_EXPAND_FILL
			buttonTile.size_flags_vertical = ColorRect.SIZE_EXPAND_FILL
			buttonTile.expand = true
#			buttonTile.material = ShaderMaterial.new()
#			buttonTile.material.shader = shader
#			buttonTile.material.set("shader_param/line_color", Color(globvar.outline))
#			buttonTile.material = null
			board.add_child(buttonTile)
			buttonTiles.append(buttonTile)
	
func movePiece(j: int, i: int):
	var aux = boardArray[j-1][i-1]
	boardArray[j-1][i-1] = selectedPiece
	if selectedPiece <= 6:
		turn = 0
	else:
		 turn = 1# promote white pawn
	if selectedPiece == 1 && j == 1:
		board.visible = false
		colorBoard.visible = false
		promoteWhite.visible = true
		promotePawni = i
		promotePawnj = j
	# promote black pawn
	if selectedPiece == 7 && j == 8:
		board.visible = false
		colorBoard.visible = false
		promoteBlack.visible = true
		promotePawni = i
		promotePawnj = j
		
	selectedPiece = -1
	boardArray[last_j-1][last_i-1] = 0
	if last_j == 8 && last_i == 1:
		whiteCastleLeft = 0
	elif last_j == 8 && last_i == 8:
		whiteCastleRight = 0
	if last_j == 1 && last_i == 1:
		blackCastleLeft = 0
	elif last_j == 1 && last_i == 8:
		blackCastleRight = 0
	last_j = j
	last_i = i
	enPassantWhite = [0, 0, 0, 0, 0, 0, 0, 0]
	enPassantBlack = [0, 0, 0, 0, 0, 0, 0, 0]
#this is where it actually moves the pieces and it checks if the moves are valid. it's a mess.
func _button_up(j: int, i: int):
#	refreshTextures()
	print(j, " ", i, " ", selectedPiece)
	# j = line, i = column
	#this is where you actually select the piece
	if(selectedPiece == -1 && boardArray[j-1][i-1] != 0 && boardArray[j-1][i-1] <=6 && turn == false):
		selectedPiece = boardArray[j-1][i-1]
		last_j = j
		last_i = i
	if(selectedPiece == -1 && boardArray[j-1][i-1] != 0 && boardArray[j-1][i-1] >=7 && turn == true):
		selectedPiece = boardArray[j-1][i-1]
		last_j = j
		last_i = i
	if(selectedPiece == -1 && boardArray[j-1][i-1] != 0):
		selectedPiece = boardArray[j-1][i-1]
		last_j = j
		last_i = i
	#this unselects it if you click the selected piece
	elif(i == last_i && j == last_j): 
		boardArray[j-1][i-1] = selectedPiece
		selectedPiece = -1
	#white pawn logic
	elif(selectedPiece == 1):
		#this unselects it if you click a same color piece
		if boardArray[j-1][i-1]<=6 && boardArray[j-1][i-1] != 0:
			selectedPiece = -1
		#this is how it moves
		elif last_j == 7 && boardArray[6][i-1] == 1 && last_j == j+2 && last_i == i && boardArray[j-1][i-1] == 0 && boardArray[j][i-1] == 0:
			movePiece(j, i)
			enPassantWhite[i-1] = 1
		elif last_j == j+1 && last_i == i && boardArray[j-1][i-1] == 0:
			movePiece(j, i)
		#this is how it captures
		elif last_j == j+1 && last_i == i+1 && boardArray[j-1][i-1] >=7 && boardArray[j-1][i-1] != 0:
			movePiece(j, i)
		elif last_j == j+1 && last_i == i-1 && boardArray[j-1][i-1] >=7 && boardArray[j-1][i-1] != 0:
			movePiece(j, i)
		#this is how it performs an en passant
		elif last_j == 4 && j == 3 && last_i == i-1 && enPassantBlack[i-1]!=0:
			movePiece(j, i)
			boardArray[3][i-1]=0
		elif last_j == 4 && j == 3 && last_i == i+1 && enPassantBlack[i-1]!=0:
			movePiece(j, i)
			boardArray[3][i-1]=0
		#this unselects it if none of the moves are valid
		else:
			selectedPiece = -1
	#black pawn logic
	elif(selectedPiece == 7):
		#this unselects it if you click a same color piece
		if boardArray[j-1][i-1]>=7 && boardArray[j-1][i-1] != 0:
			selectedPiece = -1
		#this is how it moves
		elif last_j == 2 && boardArray[2-1][i-1] == 7 && last_j == j-2 && last_i == i && boardArray[j-1][i-1] == 0 && boardArray[j-2][i-1] == 0:
			movePiece(j, i)
			enPassantBlack[i-1]=1
		elif boardArray[1][i-1] == 7 && last_j == j && last_i == i && boardArray[j-1][i-1] == 0 && boardArray[j-2][i-1] == 0:
			movePiece(j, i)
			enPassantBlack[i-1] = 1
		elif last_j == j-1 && last_i == i && boardArray[j-1][i-1] == 0:
			movePiece(j, i)
		#this is how it captures
		elif last_j == j-1 && last_i == i+1 && boardArray[j-1][i-1] <=6 && boardArray[j-1][i-1] != 0:
			movePiece(j, i)
		elif last_j == j-1 && last_i == i-1 && boardArray[j-1][i-1] <=6 && boardArray[j-1][i-1] != 0:
			movePiece(j, i)
		#this is how it performs an en passant
		elif last_j == 5 && j == 6 && last_i == i-1 && enPassantWhite[i-1]!=0:
			movePiece(j, i)
			boardArray[4][i-1]=0
		elif last_j == 5 && j == 6 && last_i == i+1 && enPassantWhite[i-1]!=0:
			movePiece(j, i)
			boardArray[4][i-1]=0
		#this unselects it if none of the moves are valid
		else:
			selectedPiece = -1
	#white rook logic
	elif(selectedPiece == 2):
		#this unselects it if you click a same color piece
		if boardArray[j-1][i-1]<=6 && boardArray[j-1][i-1] != 0:
			selectedPiece = -1
		#this checks if it moves horizontally or diagonally
		elif last_j == j:
			if i>last_i:
				var k = 0
				for m in range(last_i+1, i, +1):
					if boardArray[j-1][m-1] !=0:
						k = 1
				if k==0:
					movePiece(j, i)
				else:
					selectedPiece = -1
			elif i<last_i:
				var k = 0
				for m in range(last_i-1, i, -1):
					if boardArray[j-1][m-1] !=0:
						k = 1
				if k==0:
					movePiece(j, i)
				else:
					selectedPiece = -1
		elif last_i == i:
			if j>last_j:
				var k = 0
				for m in range(last_j+1, j, +1):
					if boardArray[m-1][i-1] !=0:
						k = 1
				if k==0:
					movePiece(j, i)
				else:
					selectedPiece = -1
			elif j<last_j:
				var k = 0
				for m in range(last_j-1, j, -1):
					if boardArray[m-1][i-1] !=0:
						k = 1
				if k==0:
					movePiece(j, i)
				else:
					selectedPiece = -1
		else:
			selectedPiece = -1
	#black rook logic
	elif(selectedPiece == 8):
		#this unselects it if you click a same color piece
		if boardArray[j-1][i-1]>=7 && boardArray[j-1][i-1] != 0:
			selectedPiece = -1
		#this checks if it moves horizontally or diagonally
		elif last_j == j:
			if i>last_i:
				var k = 0
				for m in range(last_i+1, i, +1):
					if boardArray[j-1][m-1] !=0:
						k = 1
				if k==0:
					movePiece(j, i)
				else:
					selectedPiece = -1
			elif i<last_i:
				var k = 0
				for m in range(last_i-1, i, -1):
					if boardArray[j-1][m-1] !=0:
						k = 1
				if k==0:
					movePiece(j, i)
				else:
					selectedPiece = -1
		elif last_i == i:
			if j>last_j:
				var k = 0
				for m in range(last_j+1, j, +1):
					if boardArray[m-1][i-1] !=0:
						k = 1
				if k==0:
					movePiece(j, i)
				else:
					selectedPiece = -1
			elif j<last_j:
				var k = 0
				for m in range(last_j-1, j, -1):
					if boardArray[m-1][i-1] !=0:
						k = 1
				if k==0:
					movePiece(j, i)
				else:
					selectedPiece = -1
		else:
			selectedPiece = -1
	#white knight logic
	elif(selectedPiece == 3):
		#this unselects it if you click a same color piece
		if boardArray[j-1][i-1]<=6 && boardArray[j-1][i-1] != 0:
			selectedPiece = -1
		elif j == last_j+2 && i == last_i-1:
			movePiece(j, i)
		elif j == last_j+1 && i == last_i-2:
			movePiece(j, i)
		elif j == last_j-1 && i == last_i-2:
			movePiece(j, i)
		elif j == last_j-2 && i == last_i-1:
			movePiece(j, i)
		elif j == last_j-2 && i == last_i+1:
			movePiece(j, i)
		elif j == last_j-1 && i == last_i+2:
			movePiece(j, i)
		elif j == last_j+1 && i == last_i+2:
			movePiece(j, i)
		elif j == last_j+2 && i == last_i+1:
			movePiece(j, i)
		else:
			selectedPiece = -1
	#black knight logic
	elif(selectedPiece == 9):
		#this unselects it if you click a same color piece
		if boardArray[j-1][i-1]>=7 && boardArray[j-1][i-1] != 0:
			selectedPiece = -1
		elif j == last_j+2 && i == last_i-1:
			movePiece(j, i)
		elif j == last_j+1 && i == last_i-2:
			movePiece(j, i)
		elif j == last_j-1 && i == last_i-2:
			movePiece(j, i)
		elif j == last_j-2 && i == last_i-1:
			movePiece(j, i)
		elif j == last_j-2 && i == last_i+1:
			movePiece(j, i)
		elif j == last_j-1 && i == last_i+2:
			movePiece(j, i)
		elif j == last_j+1 && i == last_i+2:
			movePiece(j, i)
		elif j == last_j+2 && i == last_i+1:
			movePiece(j, i)
		else:
			selectedPiece = -1
	#white bishop logic
	elif(selectedPiece == 4):
		#this unselects it if you click a same color piece
		if boardArray[j-1][i-1]<=6 && boardArray[j-1][i-1] != 0:
			selectedPiece = -1
		elif j<last_j && i<last_i:
				var k = 0
				var m = 1
				while (last_i-m)>=1 && (last_j-m)>=1:
					if last_j-m == j && last_i-m == i && k==0:
						movePiece(j, i)
					elif boardArray[last_j-1-m][last_i-1-m] !=0:
						k = 1
						print(boardArray[last_j-1-m][last_i-1-m])
					m+=1
				selectedPiece = -1
		elif j>last_j && i<last_i:
				var k = 0
				var m = 1
				while (last_i-m)>=1 && (last_j+m)<=8:
					if last_j+m == j && last_i-m == i && k==0:
						movePiece(j, i)
					elif boardArray[last_j-1+m][last_i-1-m] !=0:
						k = 1
						print(boardArray[last_j-1+m][last_i-1-m])
					m+=1
				selectedPiece = -1
		elif j<last_j && i>last_i:
				var k = 0
				var m = 1
				while (last_i+m)<=8 && (last_j-m)>=1:
					if last_j-m == j && last_i+m == i && k==0:
						movePiece(j, i)
					elif boardArray[last_j-1-m][last_i-1+m] !=0:
						k = 1
						print(boardArray[last_j-1-m][last_i-1+m])
					m+=1
				selectedPiece = -1
		elif j>last_j && i>last_i:
				var k = 0
				var m = 1
				while (last_i+m)<=8 && (last_j+m)<=8:
					if last_j+m == j && last_i+m == i && k==0:
						movePiece(j, i)
					elif boardArray[last_j-1+m][last_i-1+m] !=0:
						k = 1
						print(boardArray[last_j-1+m][last_i-1+m])
					m+=1
				selectedPiece = -1
	#black bishop logic
	elif(selectedPiece == 10):
		#this unselects it if you click a same color piece
		if boardArray[j-1][i-1]>=7 && boardArray[j-1][i-1] != 0:
			selectedPiece = -1
		elif j<last_j && i<last_i:
				var k = 0
				var m = 1
				while (last_i-m)>=1 && (last_j-m)>=1:
					if last_j-m == j && last_i-m == i && k==0:
						movePiece(j, i)
					elif boardArray[last_j-1-m][last_i-1-m] !=0:
						k = 1
						print(boardArray[last_j-1-m][last_i-1-m])
					m+=1
				selectedPiece = -1
		elif j>last_j && i<last_i:
				var k = 0
				var m = 1
				while (last_i-m)>=1 && (last_j+m)<=8:
					if last_j+m == j && last_i-m == i && k==0:
						movePiece(j, i)
					elif boardArray[last_j-1+m][last_i-1-m] !=0:
						k = 1
						print(boardArray[last_j-1+m][last_i-1-m])
					m+=1
				selectedPiece = -1
		elif j<last_j && i>last_i:
				var k = 0
				var m = 1
				while (last_i+m)<=8 && (last_j-m)>=1:
					if last_j-m == j && last_i+m == i && k==0:
						movePiece(j, i)
					elif boardArray[last_j-1-m][last_i-1+m] !=0:
						k = 1
						print(boardArray[last_j-1-m][last_i-1+m])
					m+=1
				selectedPiece = -1
		elif j>last_j && i>last_i:
				var k = 0
				var m = 1
				while (last_i+m)<=8 && (last_j+m)<=8:
					if last_j+m == j && last_i+m == i && k==0:
						movePiece(j, i)
					elif boardArray[last_j-1+m][last_i-1+m] !=0:
						k = 1
						print(boardArray[last_j-1+m][last_i-1+m])
					m+=1
				selectedPiece = -1
	#white queen logic
	elif(selectedPiece == 5):
		#this unselects it if you click a same color piece
		if boardArray[j-1][i-1]<=6 && boardArray[j-1][i-1] != 0:
			selectedPiece = -1
		#this checks if it moves horizontally or diagonally
		elif last_j == j:
			if i>last_i:
				var k = 0
				for m in range(last_i+1, i, +1):
					if boardArray[j-1][m-1] !=0:
						k = 1
				if k==0:
					movePiece(j, i)
				else:
					selectedPiece = -1
			elif i<last_i:
				var k = 0
				for m in range(last_i-1, i, -1):
					if boardArray[j-1][m-1] !=0:
						k = 1
				if k==0:
					movePiece(j, i)
				else:
					selectedPiece = -1
		elif last_i == i:
			if j>last_j:
				var k = 0
				for m in range(last_j+1, j, +1):
					if boardArray[m-1][i-1] !=0:
						k = 1
				if k==0:
					movePiece(j, i)
				else:
					selectedPiece = -1
			elif j<last_j:
				var k = 0
				for m in range(last_j-1, j, -1):
					if boardArray[m-1][i-1] !=0:
						k = 1
				if k==0:
					movePiece(j, i)
				else:
					selectedPiece = -1
		elif j<last_j && i<last_i:
				var k = 0
				var m = 1
				while (last_i-m)>=1 && (last_j-m)>=1:
					if last_j-m == j && last_i-m == i && k==0:
						movePiece(j, i)
					elif boardArray[last_j-1-m][last_i-1-m] !=0:
						k = 1
						print(boardArray[last_j-1-m][last_i-1-m])
					m+=1
				selectedPiece = -1
		elif j>last_j && i<last_i:
				var k = 0
				var m = 1
				while (last_i-m)>=1 && (last_j+m)<=8:
					if last_j+m == j && last_i-m == i && k==0:
						movePiece(j, i)
					elif boardArray[last_j-1+m][last_i-1-m] !=0:
						k = 1
						print(boardArray[last_j-1+m][last_i-1-m])
					m+=1
				selectedPiece = -1
		elif j<last_j && i>last_i:
				var k = 0
				var m = 1
				while (last_i+m)<=8 && (last_j-m)>=1:
					if last_j-m == j && last_i+m == i && k==0:
						movePiece(j, i)
					elif boardArray[last_j-1-m][last_i-1+m] !=0:
						k = 1
						print(boardArray[last_j-1-m][last_i-1+m])
					m+=1
				selectedPiece = -1
		elif j>last_j && i>last_i:
				var k = 0
				var m = 1
				while (last_i+m)<=8 && (last_j+m)<=8:
					if last_j+m == j && last_i+m == i && k==0:
						movePiece(j, i)
					elif boardArray[last_j-1+m][last_i-1+m] !=0:
						k = 1
						print(boardArray[last_j-1+m][last_i-1+m])
					m+=1
				selectedPiece = -1
		else:
			selectedPiece = -1
	#black queen logic
	elif(selectedPiece == 11):
		#this unselects it if you click a same color piece
		if boardArray[j-1][i-1]>=7 && boardArray[j-1][i-1] != 0:
			selectedPiece = -1
		#this checks if it moves horizontally or diagonally
		elif last_j == j:
			if i>last_i:
				var k = 0
				for m in range(last_i+1, i, +1):
					if boardArray[j-1][m-1] !=0:
						k = 1
				if k==0:
					movePiece(j, i)
				else:
					selectedPiece = -1
			elif i<last_i:
				var k = 0
				for m in range(last_i-1, i, -1):
					if boardArray[j-1][m-1] !=0:
						k = 1
				if k==0:
					movePiece(j, i)
				else:
					selectedPiece = -1
		elif last_i == i:
			if j>last_j:
				var k = 0
				for m in range(last_j+1, j, +1):
					if boardArray[m-1][i-1] !=0:
						k = 1
				if k==0:
					movePiece(j, i)
				else:
					selectedPiece = -1
			elif j<last_j:
				var k = 0
				for m in range(last_j-1, j, -1):
					if boardArray[m-1][i-1] !=0:
						k = 1
				if k==0:
					movePiece(j, i)
				else:
					selectedPiece = -1
		elif j<last_j && i<last_i:
				var k = 0
				var m = 1
				while (last_i-m)>=1 && (last_j-m)>=1:
					if last_j-m == j && last_i-m == i && k==0:
						movePiece(j, i)
					elif boardArray[last_j-1-m][last_i-1-m] !=0:
						k = 1
						print(boardArray[last_j-1-m][last_i-1-m])
					m+=1
				selectedPiece = -1
		elif j>last_j && i<last_i:
				var k = 0
				var m = 1
				while (last_i-m)>=1 && (last_j+m)<=8:
					if last_j+m == j && last_i-m == i && k==0:
						movePiece(j, i)
					elif boardArray[last_j-1+m][last_i-1-m] !=0:
						k = 1
						print(boardArray[last_j-1+m][last_i-1-m])
					m+=1
				selectedPiece = -1
		elif j<last_j && i>last_i:
				var k = 0
				var m = 1
				while (last_i+m)<=8 && (last_j-m)>=1:
					if last_j-m == j && last_i+m == i && k==0:
						movePiece(j, i)
					elif boardArray[last_j-1-m][last_i-1+m] !=0:
						k = 1
						print(boardArray[last_j-1-m][last_i-1+m])
					m+=1
				selectedPiece = -1
		elif j>last_j && i>last_i:
				var k = 0
				var m = 1
				while (last_i+m)<=8 && (last_j+m)<=8:
					if last_j+m == j && last_i+m == i && k==0:
						movePiece(j, i)
					elif boardArray[last_j-1+m][last_i-1+m] !=0:
						k = 1
						print(boardArray[last_j-1+m][last_i-1+m])
					m+=1
				selectedPiece = -1
		else:
			selectedPiece = -1
	#white king logic
	elif(selectedPiece == 6):
		#this unselects it if you click a same color piece
		if boardArray[j-1][i-1]<=6 && boardArray[j-1][i-1] != 0:
			selectedPiece = -1
		elif j == 8 && i == 7 && whiteCastleRight == 1 && boardArray[7][6]==0 && boardArray[7][5]==0:
			movePiece(j, i)
			boardArray[7][7]=0
			boardArray[7][5]=2
		elif j == 8 && i == 3 && whiteCastleLeft == 1 && boardArray[7][1] == 0 && boardArray[7][2] == 0 && boardArray[7][3] == 0:
			movePiece(j, i)
			boardArray[7][0]=0
			boardArray[7][3]=2
		elif j == last_j-1 && i == last_i-1:
			movePiece(j, i)
			whiteCastleRight = 0
			whiteCastleLeft = 0
		elif j == last_j-1 && i == last_i:
			movePiece(j, i)
			whiteCastleRight = 0
			whiteCastleLeft = 0
		elif j == last_j-1 && i == last_i+1:
			movePiece(j, i)
			whiteCastleRight = 0
			whiteCastleLeft = 0
		elif j == last_j && i == last_i-1:
			movePiece(j, i)
			whiteCastleRight = 0
			whiteCastleLeft = 0
		elif j == last_j && i == last_i+1:
			movePiece(j, i)
			whiteCastleRight = 0
			whiteCastleLeft = 0
		elif j == last_j+1 && i == last_i-1:
			movePiece(j, i)
			whiteCastleRight = 0
			whiteCastleLeft = 0
		elif j == last_j+1 && i == last_i:
			movePiece(j, i)
			whiteCastleRight = 0
			whiteCastleLeft = 0
		elif j == last_j+1 && i == last_i+1:
			movePiece(j, i)
			whiteCastleRight = 0
			whiteCastleLeft = 0
	#black king logic
	elif(selectedPiece == 12):
		#this unselects it if you click a same color piece
		if boardArray[j-1][i-1]>=7 && boardArray[j-1][i-1] != 0:
			selectedPiece = -1
		elif j == 1 && i == 7 && blackCastleRight == 1 && boardArray[0][6]==0 && boardArray[0][5]==0:
			movePiece(j, i)
			boardArray[0][7]=0
			boardArray[0][5]=8
		elif j == 1 && i == 3 && blackCastleLeft == 1 && boardArray[0][1] == 0 && boardArray[0][2] == 0 && boardArray[0][3] == 0:
			movePiece(j, i)
			boardArray[0][0]=0
			boardArray[0][3]=8
		elif j == last_j-1 && i == last_i-1:
			movePiece(j, i)
			blackCastleRight = 0
			blackCastleLeft = 0
		elif j == last_j-1 && i == last_i:
			movePiece(j, i)
			blackCastleRight = 0
			blackCastleLeft = 0
		elif j == last_j-1 && i == last_i+1:
			movePiece(j, i)
			blackCastleRight = 0
			blackCastleLeft = 0
		elif j == last_j && i == last_i-1:
			movePiece(j, i)
			blackCastleRight = 0
			blackCastleLeft = 0
		elif j == last_j && i == last_i+1:
			movePiece(j, i)
			blackCastleRight = 0
			blackCastleLeft = 0
		elif j == last_j+1 && i == last_i-1:
			movePiece(j, i)
			blackCastleRight = 0
			blackCastleLeft = 0
		elif j == last_j+1 && i == last_i:
			movePiece(j, i)
			blackCastleRight = 0
			blackCastleLeft = 0
		elif j == last_j+1 && i == last_i+1:
			movePiece(j, i)
			blackCastleRight = 0
			blackCastleLeft = 0
	#this moves any piece anywhere and changes turn accordingly
#	elif(selectedPiece != -1):
#		movePiece(j, i)
	refreshTextures()

#this sets the pieces for the game to start
func startingPos():
	var j = 1
	var i = 1
	var nr = 0
	var x = 0
#	var done = 0
	var leng = startingPositions.length()
#	while(done == 0):
#		if globvar.startPos[x].is_valid_float():
#			nr = int(globvar.startPos[x])
#			while nr > 0:
#				boardArray[j-1][i-1] = 0
#				nr-=1
#				i+=1
#			x+=1
#		elif globvar.startPos[x] == "/" :
#			j+=1
#			i=1
#			x+=1
#		elif advance_ix(globvar):
#			i += 1
#			x += 1
#			boardArray[j-1][i-1] = dictionary[globvar.startPos[x]]
#		if i==8 && j == 8:
#			done = 1
	while((leng - x) > 0):
		if globvar.startPos[x].is_valid_float():
			nr = int(globvar.startPos[x])
			while nr > 0:
				boardArray[j-1][i-1] = 0
				nr-=1
				i+=1
			x+=1
		elif globvar.startPos[x] == "/" :
			j+=1
			i=1
			x+=1
		elif globvar.startPos[x] == "P" : 
			boardArray[j-1][i-1] = 1
			i+=1
			x+=1
		elif globvar.startPos[x] == "R" :
			boardArray[j-1][i-1] = 2
			i+=1
			x+=1
		elif globvar.startPos[x] == "N" : 
			boardArray[j-1][i-1] = 3
			i+=1
			x+=1
		elif globvar.startPos[x] == "B" :
			boardArray[j-1][i-1] = 4
			i+=1
			x+=1
		elif globvar.startPos[x] == "Q" : 
			boardArray[j-1][i-1] = 5
			i+=1
			x+=1
		elif globvar.startPos[x] == "K" :
			boardArray[j-1][i-1] = 6
			i+=1
			x+=1
		elif globvar.startPos[x] == "p" : 
			boardArray[j-1][i-1] = 7
			i+=1
			x+=1
		elif globvar.startPos[x] == "r" :
			boardArray[j-1][i-1] = 8
			i+=1
			x+=1
		elif globvar.startPos[x] == "n" : 
			boardArray[j-1][i-1] = 9
			i+=1
			x+=1
		elif globvar.startPos[x] == "b" :
			boardArray[j-1][i-1] = 10
			i+=1
			x+=1
		elif globvar.startPos[x] == "q" : 
			boardArray[j-1][i-1] = 11
			i+=1
			x+=1
		elif globvar.startPos[x] == "k" :
			boardArray[j-1][i-1] = 12
			i+=1
			x+=1

func refreshTextures():
	var whiteHasKing = 0
	var blackHasKing = 0
	for j in range(0, 8):
		for i in range(0, 8):
			if(turn || globvar.passandplaymode == 0):
				buttonTiles[((j-1)*8+i)].set_normal_texture(texture_dict[boardArray[j-1][i]])
				buttonTiles[((j-1)*8+i)].material = null
			else:
				buttonTiles[((j-1)*8+i)].set_normal_texture(texture_dict_flipped[boardArray[j-1][i]])
				buttonTiles[((j-1)*8+i)].material = null
			if boardArray[j-1][i-1] == 6:
				whiteHasKing = 1
			if boardArray[j-1][i-1] == 12:
				blackHasKing = 1
#	if(turn):
##		var bk = preload("res://Assets/Pieces Black/black_king.png")
#		turnDisplay.color = Color(globvar.white)
#	else:
##		var bk = preload("res://Assets/Pieces Black Flipped/black_king_flipped.png")
#		turnDisplay.color = Color(globvar.black)
	if whiteHasKing == 0:
		winDisplay.text = "Black Wins!"
		for j in range(0, 8):
			for i in range(0, 8):
				buttonTiles[((j-1)*8+i)].disabled = true;
	if blackHasKing == 0:
		winDisplay.text = "White Wins!"
		for j in range(0, 8):
			for i in range(0, 8):
				buttonTiles[((j-1)*8+i)].disabled = true;
	if(selectedPiece != -1):
		buttonTiles[((last_j-1)*8+last_i-1)].material = ShaderMaterial.new()
		buttonTiles[((last_j-1)*8+last_i-1)].material.shader = shader
		buttonTiles[((last_j-1)*8+last_i-1)].material.set("shader_param/line_color", Color("#c388dd"))
#		buttonTile.material = ShaderMaterial.new()
#		buttonTile.material.shader = shader
#		buttonTile.material.set("shader_param/line_color", Color(globvar.outline))

func _ready():
	boardColor()
	boardFunction()
	createArray()
	startingPos()
	refreshTextures()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#
# 0 - no piece
# 1 wpawn	7 bpawn
# 2 wrook	8 brook
# 3 wknight	9 bknight
# 4 wbishop	10 bbishop
# 5 wqueen	11 bqueen
# 6 wking	12 bking


func _on_wpromoteToBishop_button_up():
	boardArray[promotePawnj-1][promotePawni-1] = 4
	board.visible = true
	colorBoard.visible = true
	promoteWhite.visible = false
	refreshTextures()

#this is all the promotion buttons

func _on_wpromoteToRook_button_up():
	boardArray[promotePawnj-1][promotePawni-1] = 2
	board.visible = true
	colorBoard.visible = true
	promoteWhite.visible = false
	refreshTextures()


func _on_wpromoteToKnight_button_up():
	boardArray[promotePawnj-1][promotePawni-1] = 3
	board.visible = true
	colorBoard.visible = true
	promoteWhite.visible = false
	refreshTextures()


func _on_wpromoteToQueen_button_up():
	boardArray[promotePawnj-1][promotePawni-1] = 5
	board.visible = true
	colorBoard.visible = true
	promoteWhite.visible = false
	refreshTextures()


func _on_bpromoteToBishop_button_up():
	boardArray[promotePawnj-1][promotePawni-1] = 10
	board.visible = true
	colorBoard.visible = true
	promoteBlack.visible = false
	refreshTextures()


func _on_bpromoteToRook_button_up():
	boardArray[promotePawnj-1][promotePawni-1] = 8
	board.visible = true
	colorBoard.visible = true
	promoteBlack.visible = false
	refreshTextures()


func _on_bpromoteToKnight_button_up():
	boardArray[promotePawnj-1][promotePawni-1] = 9
	board.visible = true
	colorBoard.visible = true
	promoteBlack.visible = false
	refreshTextures()


func _on_bpromoteToQueen_button_up():
	boardArray[promotePawnj-1][promotePawni-1] = 11
	board.visible = true
	colorBoard.visible = true
	promoteBlack.visible = false
	refreshTextures()

#this is the return button

func _on_Button_button_up():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
