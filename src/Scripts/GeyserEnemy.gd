extends StaticBody2D

var timer = null
var can_attack = true
var jet_scene = preload("res://Scenes/GeyserJet.tscn")
export(int) var attack_delay = 4
var health = 0 # Health variable as this node will be picked up by player bullet code
var has_seen_player = false # Just here so the bullet code doesn't bug

func _ready():
	setup_timer()
	set_process(true)

func _process(delta):
	attack()

func setup_timer():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(attack_delay)
	timer.connect("timeout", self, "_on_timer_attack")
	add_child(timer)

func _on_timer_attack():
	can_attack = true

func attack():
	if can_attack:
		var jet = jet_scene.instance()
		jet.set_pos(get_pos())
		jet.set_rot(get_rot())
		get_tree().get_root().get_node("World").add_child(jet)
		can_attack = false
		timer.start()