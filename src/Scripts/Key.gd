extends Area2D

func _ready():
	pass

func _on_Key_area_enter(area):
	if area.get_name() == "PlayerArea":
		var p = area.get_parent()
		p.keys += 1
		self.queue_free()