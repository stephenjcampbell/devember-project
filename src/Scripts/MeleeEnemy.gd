extends KinematicBody2D

export(int) var max_health = 20
var health = max_health
export(int) var damage = 5
export(int) var attack_delay = 0.5
var has_seen_player = false
export(int) var movement_speed = 200
export(int) var player_detection_distance = 768
export(int) var player_caught_distance = 84
export(int) var player_lost_distance = 1024
const gravity = 1800
var speed_y = 0
var speed_x = 0
var timer = null
var can_attack = true

func _ready():
	set_process(true)
	setup_timer()
	get_node("HealthBar").set_max(max_health)
	
func _process(delta):
	speed_x = 0
	var player_pos = get_tree().get_root().get_node("World").get_node("Player").get_pos()
	
	# Enemy has caught player, attack
	if get_pos().distance_to(player_pos) <= player_caught_distance:
		attack_player()
	else:
		# If enemy has seen the player, start tracking towards the player
		if has_seen_player && get_pos().distance_to(player_pos) > player_caught_distance:
			if player_pos.x < get_pos().x:
				if !get_node("Sprite").is_flipped_h():
					get_node("Sprite").set_flip_h(true);
			else:
				if get_node("Sprite").is_flipped_h():
					get_node("Sprite").set_flip_h(false);
			move_to_player(delta, player_pos)
		else:
			# Check if enemy can see the player
			detect_player_visibility(player_pos)
			enact_gravity(delta, 0)
		# If player gets too far away, enemy gives up and stops tracking
		if get_pos().distance_to(player_pos) > player_lost_distance:
			has_seen_player = false
	
	update_health()
	if health <= 0:
		queue_free()
		
func setup_timer():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(attack_delay)
	timer.connect("timeout", self, "_on_timer_attack")
	add_child(timer)

func _on_timer_attack():
	can_attack = true

func attack_player():
	if can_attack:
		var player = get_tree().get_root().get_node("World").get_node("Player")
		player.health -= damage
		can_attack = false
		timer.start()

func enact_gravity(delta, speed_x):
	# Apply gravity
	speed_y += gravity * delta
	var movement_vector = Vector2(-speed_x * delta, speed_y * delta)
	var movement_remainder = move(movement_vector)
	if is_colliding():
		var normal = get_collision_normal()
		var final_movement = normal.slide(movement_remainder)
		speed_y = normal.slide(Vector2(0, speed_y)).y
		move(final_movement)

func move_to_player(delta, player_pos):
		# Move towards the player. Gravity is applied if the enemy is falling
		speed_x = Vector2(get_pos().x - player_pos.x, 0).normalized().x
		speed_x = speed_x * movement_speed
		enact_gravity(delta, speed_x)


func detect_player_visibility(player_pos):
	# Cast ray to player to check if any objects are between the player and the enemy
	var space_state = get_world_2d().get_direct_space_state()
	var result = space_state.intersect_ray(get_global_pos(), player_pos, [ self ] )
	
	# If there are no objects between the player and the player is close enough, enemy has seen the player
	if (not result.empty() && get_pos().distance_to(player_pos) < player_detection_distance ):
		if result.collider_id == get_tree().get_root().get_node("World").get_node("Player").get_instance_ID():
			has_seen_player = true

func update_health():
	get_node("HealthBar").set_value(health)

func _on_DetectionArea_area_enter( area ):
	if area.get_name() == "PlayerArea":
		pass
