extends KinematicBody2D

var velocity = Vector2()
var impact_scene = preload("res://Scenes/BulletImpact.tscn")
var bullet_damage = 5
var bullet_impact_linear_modifier = 0.2 # 1 = 100% of bullet force
var bullet_impact_angular_modifier = 3 # 1 = 100% of bullet force

func _ready():
	set_process(true)
	add_collision_exception_with(get_tree().get_root().get_node("World").get_node("Player"))

func _process(delta):
	move(velocity * delta)
	if is_colliding():
		# If colliding with a physics object, add a force to that object so the bullet appears to be moving it
		if get_collider().get_type() == "RigidBody2D":
			var bullet_impact_linear_vector = Vector2(velocity.x * bullet_impact_linear_modifier, velocity.y * bullet_impact_linear_modifier)
			get_collider().set_linear_velocity(bullet_impact_linear_vector)
			var bullet_impact_angle = get_collider().get_pos().angle_to_point(get_collision_pos());
			get_collider().set_angular_velocity(get_collider().get_rot() + bullet_impact_angle * bullet_impact_angular_modifier)
		
		# If colliding with an enemy, damage their health
		if "Enemy" in get_collider().get_name():
			get_collider().health = get_collider().health - bullet_damage
			get_collider().has_seen_player = true
		
		# Upon collision with anything, draw the impact particle effect
		var impact = impact_scene.instance()
		get_tree().get_root().get_node("World").add_child(impact)
		impact.set_pos(get_collision_pos())
		impact.set_rot(get_rot())
		
		# Remove the bullet
		queue_free()

func set_vel(vector):
	velocity = vector
