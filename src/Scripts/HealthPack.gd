extends Area2D

export(int) var health = 20

func _ready():
	pass

func _on_HealthPack_area_enter( area ):
	if area.get_name() == "PlayerArea":
		var p = area.get_parent()
		p.health += health
		if p.health > p.max_health:
			p.health = p.max_health
		self.queue_free()
