extends Area2D

var can_save = false
var dialog_scene = preload("res://Scenes/DialogBox.tscn")

func _ready():
	set_process(true)
	
func _process(delta):
	if can_save and Input.is_action_pressed("ui_up"):
		# Save game
		get_node("Panel").hide()
		can_save = false
		save_game()
		
		# Notify player that the game has been saved
		var dialog = dialog_scene.instance()
		dialog.get_node("Label").set_text("Game saved.")
		get_tree().get_root().get_node("World").get_node("Player").get_node("Camera2D/CanvasLayer").add_child(dialog)
		dialog.show()
		get_tree().set_pause(true)
		

func save_game():
	var packed_scene = PackedScene.new()
	packed_scene.pack(get_tree().get_current_scene())
	ResourceSaver.save("res://savegame.tscn", packed_scene)
	
func _on_Checkpoint_area_enter( area ):
	if area.get_name() == "PlayerArea":
		get_node("Panel").show()
		can_save = true

func _on_Checkpoint_area_exit( area ):
	if area.get_name() == "PlayerArea":
		get_node("Panel").hide()
		can_save = false
