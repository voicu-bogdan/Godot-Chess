extends Node

export var mainGameScene : PackedScene

func _ready():
	pass

func _on_New_Game_Button_button_up():
	get_tree().change_scene("res://Scenes/Main.tscn")

func _on_Exit_Button_button_down():
	get_tree().quit()

func _on_Options_Button_button_up():
	get_tree().change_scene("res://Scenes/Settings.tscn")
