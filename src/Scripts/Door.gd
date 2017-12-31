extends StaticBody2D

export(int) var keys_required = 2

func _ready():
	get_node("KeysLabel").set_text(str(keys_required))

func _on_Area2D_area_enter( area ):
	if area.get_name() == "PlayerArea":
		var p = area.get_parent()
		if p.keys >= keys_required:
			p.keys -= keys_required
			queue_free()
