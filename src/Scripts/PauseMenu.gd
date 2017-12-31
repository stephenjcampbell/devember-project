extends Control

func _ready():
	pass

func _on_ResumeButton_pressed():
	get_tree().set_pause(false)
	self.queue_free()

func _on_LoadGameButton_pressed():
	load_game()

func load_game():
	get_tree().change_scene("res://savegame.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()
