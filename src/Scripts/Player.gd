extends KinematicBody2D

var sprite_node = null
var timer = null
var speed_x = 0
var speed_y = 0
export(int) var coins = 0
export(int) var keys = 0

# Unlockables
export(bool) var gun_unlocked = false
export(int) var max_jumps = 1
export(int) var max_health = 100

# General player stats
export(int) var speed = 450
const bullet_speed = 1000

export(int) var jump_height = 800 
const gravity = 1800
export(int) var bullet_count = 20

var health = max_health
var bullet_scene = preload("res://Scenes/Bullet.tscn")
var pause_scene = preload("res://Scenes/PauseMenu.tscn")
var can_shoot = true
var bullet_delay = 1
var gun_state = "pistol"
var counter = 0
var jump_count = 0

func _ready():
	set_process(true)
	set_process_input(true)
	timer_for_bullet()
	sprite_node = get_node("Sprite")

func _process(delta):
	if gun_unlocked:
		if get_node("Gun").is_hidden():
			get_node("Gun").show()
		spawn_bullet()
	else:
		if not get_node("Gun").is_hidden():
			get_node("Gun").hide()
	
	if health <= 0:
		get_tree().change_scene("res://Scenes/GameOver.tscn")
	
	player_movement(delta)
	update_hud()
	var mouse_pos = get_node("Camera2D").get_global_mouse_pos()
	get_node("Gun").set_rot(get_pos().angle_to_point(mouse_pos))

func update_hud():
	# Update player status information
	get_node("Camera2D/CanvasLayer/HealthBar").set_value(health)
	get_node("Camera2D/CanvasLayer/GeneralPanel/CoinCounter").set_text(str(coins) + " coins")
	get_node("Camera2D/CanvasLayer/GeneralPanel/KeyCounter").set_text(str(keys) + " keys")
	
	if gun_unlocked:
		if get_node("Camera2D/CanvasLayer/GunPanel").is_hidden():
			get_node("Camera2D/CanvasLayer/GunPanel").show()
		
		get_node("Camera2D/CanvasLayer/GunPanel/BulletCounter").set_text(str(bullet_count) + " mana")
		if gun_state == "pistol":
			get_node("Camera2D/CanvasLayer/GunPanel/GunIndicator").set_text("Bolt")
		elif gun_state == "machine_gun":
			get_node("Camera2D/CanvasLayer/GunPanel/GunIndicator").set_text("Rapid Bolt")
		elif gun_state == "shotgun":
			get_node("Camera2D/CanvasLayer/GunPanel/GunIndicator").set_text("Scatter Bolt")
		else:
			get_node("Camera2D/CanvasLayer/GunPanel/GunIndicator").set_text("")
	else:
		if not get_node("Camera2D/CanvasLayer/GunPanel").is_hidden():
			get_node("Camera2D/CanvasLayer/GunPanel").hide()

func pause_game():
	# Pauses the game (for every node, not just the player)
	var pause_menu = pause_scene.instance()
	get_node("Camera2D/CanvasLayer").add_child(pause_menu)
	pause_menu.show()
	get_tree().set_pause(true)

func timer_for_bullet():
	# Timer is used so that the player's bullets are fired at predicable intervals
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(bullet_delay)
	timer.connect("timeout", self, "_on_timer_bullet")
	add_child(timer)

func _on_timer_bullet():
	can_shoot = true

func change_weapon():
	# Cycle through available weapon states
	counter += 1
	
	if(counter > 2):
		counter = 0
	if(counter == 0):
		gun_state = "pistol"
	elif(counter == 1):
		gun_state = "machine_gun"
	elif(counter == 2):
		gun_state = "shotgun"
	else:
		pass
	print(gun_state)
	
	if gun_state == "pistol":
		bullet_delay = 1
	elif gun_state == "machine_gun":
		bullet_delay = 0.1
	elif gun_state == "shotgun":
		bullet_delay = 1
	timer.set_wait_time(bullet_delay)

func _input(event):
	# Handle game input
	if event.is_action_pressed("change_weapon"): 
		change_weapon()
	if event.is_action_pressed("ui_cancel"):
		pause_game()
	if jump_count < max_jumps and event.is_action_pressed("jump"):
		speed_y = -jump_height
		jump_count += 1

func player_movement(delta):
	# Handle basic player left or right movement, as well as gravity
	speed_x = 0
	
	var direction = Vector2()
	if(Input.is_action_pressed("ui_left")):
		speed_x = -speed
		sprite_node.set_flip_v(true)
	if(Input.is_action_pressed("ui_right")):
		speed_x = speed
		sprite_node.set_flip_v(false)
	
	speed_y += gravity * delta
	var velocity = Vector2(speed_x * delta, speed_y * delta)
	var movement_remainder = move(velocity)
	
	if is_colliding():
		var normal = get_collision_normal()
		var final_movement = normal.slide(movement_remainder)
		speed_y = normal.slide(Vector2(0, speed_y)).y
		
		move(final_movement)
		speed_y = 0
		jump_count = 0

func spawn_bullet():
	# Handles shooting with all weapon types
	if(Input.is_action_pressed("shoot") && can_shoot):
		if(bullet_count > 0):
			var bullet_offset = 0.2
			var bullets_per_shot = 1
			
			if gun_state == "shotgun":
				bullets_per_shot = 3
			
			for bullet in range(bullets_per_shot):
				var bullet = bullet_scene.instance()
				var spawn_rotation = Vector2()
				var spawn_direction = Vector2()
				
				# Set bullet angles to match the player's aim
				# If the player is using a shotgun, add some variance to this angle for a more natural spread
				if bullets_per_shot > 1:
					var current_bullet_offset = rand_range(-bullet_offset, bullet_offset)
					spawn_rotation = get_angle_to(get_global_mouse_pos())
					spawn_direction = Vector2(sin(spawn_rotation + current_bullet_offset), cos(spawn_rotation + current_bullet_offset))
				else:
					spawn_rotation = get_angle_to(get_global_mouse_pos())
					spawn_direction = Vector2(sin(spawn_rotation), cos(spawn_rotation))
				
				# Universal bullet spawn properties
				var spawn_distance = 64
				var spawn_point = get_pos() + spawn_direction * spawn_distance
				bullet.set_pos(spawn_point)
				bullet.set_rot(spawn_rotation)
				get_tree().get_root().get_node("World").add_child(bullet)
				var spawn_vector = spawn_direction.normalized() * bullet_speed 
				bullet.set_vel(spawn_vector)
				bullet_count -=1
			can_shoot = false
			timer.start()
		else:
			pass # out of ammo
