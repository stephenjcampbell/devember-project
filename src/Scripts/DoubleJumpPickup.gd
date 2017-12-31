extends Area2D

var dialog_scene = preload("res://Scenes/DialogBox.tscn")

func _ready():
	pass


func _on_DoubleJumpPickup_area_enter( area ):
	if area.get_name() == "PlayerArea":
		var p = area.get_parent()
		p.max_jumps = 2
		
		# Notify the user of their new ability
		var dialog = dialog_scene.instance()
		dialog.get_node("Label").set_text("You have unlocked double jump! Press jump a second time in the air to double jump.")
		p.get_node("Camera2D/CanvasLayer").add_child(dialog)
		dialog.show()
		get_tree().set_pause(true)
		
		self.queue_free()
