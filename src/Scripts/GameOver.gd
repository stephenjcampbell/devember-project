extends Panel

func _ready():
	pass


func _on_BackToMenuButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
