extends Area2D

export(int) var spike_damage = 10

func _ready():
	pass
	
func _on_Spikes_area_enter(area):
	if area.get_name() == "PlayerArea":
		var p = area.get_parent()
		p.health = p.health - spike_damage
		p.speed_y = -p.jump_height
		p.jump_count = 0