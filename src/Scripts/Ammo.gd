extends Area2D

export(int) var ammo = 10

func _ready():
	pass

func _on_Ammo_area_enter( area ):
	if area.get_name() == "PlayerArea":
		var p = area.get_parent()
		p.bullet_count += ammo
		self.queue_free()