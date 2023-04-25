extends Node

onready var color_menu = $CenterContainer/VBoxContainer/MarginContainer/OptionButton
onready var pass_and_play_menu = $CenterContainer/VBoxContainer/MarginContainer5/OptionButton2
onready var FENinput = $CenterContainer/VBoxContainer/MarginContainer2/LineEdit

func add_items():
	color_menu.add_item("Classic")
	color_menu.add_item("Green")
	color_menu.add_item("Brown")
	color_menu.add_item("Purple")
	color_menu.add_item("Blue")
	color_menu.add_item("Pink")
	color_menu.add_item("Red")
	color_menu.add_item("Tournament")

	pass_and_play_menu.add_item("Default")
	pass_and_play_menu.add_item("Pass & Play")
# Called when the node enters the scene tree for the first time.
func _ready():
	add_items()
	pass

func _on_OptionButton_item_selected(index):
	var selected_color = index

	if selected_color == 0:
		globvar.white = "#ffffff"
		globvar.black = "#000000"
	if selected_color == 1:
		globvar.white = "#ebecd0"
		globvar.black = "#779556"
	if selected_color == 2:
		globvar.white = "#f0d9b7"
		globvar.black = "#b48767"
	if selected_color == 3:
		globvar.white = "#efefef"
		globvar.black = "#8877b7"
	if selected_color == 4:
		globvar.white = "#eae9d2"
		globvar.black = "#4b7399"
	if selected_color == 5:
		globvar.white = "#ffffff"
		globvar.black = "#fcd8dd"
	if selected_color == 6:
		globvar.white = "#f0d8bf"
		globvar.black = "#ba5546"
	if selected_color == 7:
		globvar.white = "#ffffff"
		globvar.black = "#32674b"
	pass # Replace with function body.


func _on_Button_button_up():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _on_LineEdit_text_entered(new_text):
	var x = 0
	var y = 1
	var whiteKings = 0
	var blackKings = 0
	var FEN = new_text.length()
	for fennumber in range (0, FEN):
		if new_text[fennumber] == "K":
			whiteKings +=1
		if new_text[fennumber] == "k":
			blackKings +=1
		if new_text[fennumber] == "/":
			if x == 8:
				x = 0
				y +=1
		elif ["p", "r", "n", "b", "q", "k", "P", "R", "N", "B", "Q", "K"].has(new_text[fennumber]):
			x+=1
		elif new_text[fennumber].is_valid_float():
			x+=int(new_text[fennumber])
	if x==8 && y==8 && whiteKings == 1 && blackKings == 1:
#		print("FEN accepted!")
		globvar.startPos = new_text
		FENinput.text = ""
		FENinput.placeholder_text = "FEN accepted"
#"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"
#"rnbqkbnr/ppppRppp/r7/2Q2N2/3Q4/6r1/PPQPPPrP/RNBQKBNR"


func _on_reset_FEN_button_up():
	globvar.startPos = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"
	FENinput.placeholder_text = "Input FEN"
	FENinput.text = ""

func _on_LineEdit_focus_entered():
	OS.show_virtual_keyboard()


func _on_OptionButton2_item_selected(index):
	var selected_mode = index
	
	if selected_mode == 0:
		globvar.passandplaymode = 0
	if selected_mode == 1:
		globvar.passandplaymode = 1
	pass 
