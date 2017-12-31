extends Area2D

var dialog_scene = preload("res://Scenes/DialogBox.tscn")


func _ready():
	pass


func _on_GunPickup_area_enter( area ):
	if area.get_name() == "PlayerArea":
		var p = area.get_parent()
		p.gun_unlocked = true
		
		# Notify the user of their new ability
		var dialog = dialog_scene.instance()
		dialog.get_node("Label").set_text("You have unlocked Bolt. Use the mouse to aim and click to shoot. Press E to cycle through weapon modes.")
		p.get_node("Camera2D/CanvasLayer").add_child(dialog)
		dialog.show()
		get_tree().set_pause(true)
		
		self.queue_free()
