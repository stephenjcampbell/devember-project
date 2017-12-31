extends Area2D

func _ready():
	pass

func _on_Coin_area_enter(area):
	if area.get_name() == "PlayerArea":
		var p = area.get_parent()
		p.coins += 1
		self.queue_free()