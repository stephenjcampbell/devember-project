extends Control

func _ready():
	pass
	
func _on_NewGameButton_pressed():
	get_tree().change_scene("res://Scenes/Level1.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_LoadGameButton_pressed():
	var save_file = File.new()
	if save_file.file_exists("res://savegame.tscn"):
		load_game()

func load_game():
	get_tree().change_scene("res://savegame.tscn")