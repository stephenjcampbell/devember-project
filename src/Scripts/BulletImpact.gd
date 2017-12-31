extends Node2D

# Lifespans below are in frames
var currentLifespan = 0
var emitterLifespan = 10
var targetLifespan = 60

func _ready():
	set_process(true)

func _process(delta):
	if currentLifespan < targetLifespan:
		currentLifespan += 1
		if currentLifespan > emitterLifespan && get_node("Particles").is_emitting():
			get_node("Particles").set_emitting(false)
	else:
		self.queue_free()
