extends KinematicBody2D

# Lifespans below are in frames
var currentLifespan = 0
var targetLifespan = 120
var damage = 30

func _ready():
	set_process(true)

func _process(delta):
	if currentLifespan < targetLifespan:
		currentLifespan += 1
	else:
		self.queue_free()

func _on_Area2D_area_enter( area ):
	if area.get_name() == "PlayerArea":
		var p = area.get_parent()
		p.health = p.health - damage
