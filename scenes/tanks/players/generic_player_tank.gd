extends CharacterBody2D

signal shoot_bullet(pos, speed_vector, speed, damage)

@export var player_name: String

# These variables should be changed from the entities and level scripts.
# Note: The skill_points variable is inside skill_upgrade_menu, it should be used via its setter and getter.
var points: int = 0
var current_level: int = 0
var previous_level_points: int = 0
var next_level_points  # No set variable type, as it can be null when the player is at max level.

var level_points_array: Array

# Player upgradeable attributes:
var bullet_damage: float
var bullet_speed: float
var reload_time: float
var precision_angle: float
var player_speed: int
var health: float
var regeneration: float

var remaining_health: float
var reload_time_left: float

var can_shoot_bullet: bool = true
var is_autofire_enabled: bool = false

var is_dead: bool = false

var life_bar_position_offset: Vector2


func _ready():
	remaining_health = health
	life_bar_position_offset = $LifeBar.position
	$LifeBar.modulate.a = 1
	
	bullet_damage = $UpgradesData.bullet_damage[0]
	bullet_speed = $UpgradesData.bullet_speed[0]
	reload_time = $UpgradesData.reload_time[0]
	precision_angle = $UpgradesData.precision_angle[0]
	player_speed = $UpgradesData.player_speed[0]
	health = $UpgradesData.health[0]
	regeneration = $UpgradesData.regeneration[0]
	remaining_health = health
	reload_time_left = reload_time
	
	$CanvasLayer/skill_upgrade_menu.set_crystals(0)
	
	level_points_array = get_parent().level_points
	next_level_points = level_points_array[0]
	upgrade_to_level(0)


func _process(delta):
	if not is_dead:
		reload_time_left -= delta
		
		# Movement and rotation
		var direction = Input.get_vector("left", "right", "up", "down")
		velocity = direction * player_speed
		
		look_at(get_global_mouse_position())
		
		rotation_degrees += 90

		move_and_slide()
		
		# Update the life_bar so it always stays where it should be
		$LifeBar.global_rotation = 0
		$LifeBar.global_position = global_position + life_bar_position_offset
		
		# Handle player input:
		if (Input.is_action_pressed("primary") or is_autofire_enabled) and reload_time_left < 0:
			# Send a signal with information about where to create the bullet, so it can be created inside level
			# Get the direction and random angle to shoot the bullet
			for marker in $BulletMarkers.get_children():
				var random_choosen_angle = randf_range(-precision_angle, precision_angle)
				var shoot_angle: float = rad_to_deg((get_global_mouse_position() - position).angle()) + random_choosen_angle + marker.rotation_degrees
				
				var shoot_direction: Vector2 = Vector2(cos(deg_to_rad(shoot_angle)), sin(deg_to_rad(shoot_angle)))
				var pos = marker.global_position
				var bullet_speed_vector = shoot_direction * bullet_speed
				
				shoot_bullet.emit(pos, bullet_speed_vector, bullet_speed, bullet_damage)

				can_shoot_bullet = false
				reload_time_left = reload_time
		
		if Input.is_action_just_pressed("autofire"):
			is_autofire_enabled = false if is_autofire_enabled else true
			
		# Regenerate the health of the tank
		if remaining_health < health:
			var health_to_regenerate: float = regeneration * delta
			
			if remaining_health + health_to_regenerate < health:
				remaining_health += health_to_regenerate
				$LifeBar.set_value(remaining_health / health * 100)
			else:
				remaining_health = health
				$LifeBar.set_value(100)


func _on_area_2d_area_entered(area):
	handle_collision(area)


func update_level_information():
	# This function is run by an entity inside the level node, when it's killed by the player.
	if current_level < len(level_points_array):
		if points >= next_level_points:
			var found_level: bool = false
			# The level of the player should be increased.
			for i in range(len(level_points_array)):
				if level_points_array[i] > points:
					found_level = true
					upgrade_to_level(i)
					break
			
			if not found_level:
				upgrade_to_level(len(level_points_array))
		
		$CanvasLayer/skill_upgrade_menu.set_level_information(current_level, points, previous_level_points, next_level_points)


func upgrade_to_level(new_level):
	var old_level = current_level
	current_level = new_level
	previous_level_points = level_points_array[current_level - 1] if current_level != 0 else 0
	next_level_points = level_points_array[current_level] if current_level < len(level_points_array) else null
	$CanvasLayer/skill_upgrade_menu.set_skill_points($CanvasLayer/skill_upgrade_menu.get_skill_points() + current_level - old_level)
	$CanvasLayer/skill_upgrade_menu.set_level_information(current_level, points, previous_level_points, next_level_points)


func add_crystals(amount):
	$CanvasLayer/skill_upgrade_menu.set_crystals($CanvasLayer/skill_upgrade_menu.get_crystals() + amount)


func die():
	print("Player died (placeholder)")
	is_dead = true
	modulate.a = 0


func handle_collision(area):
	if not is_dead:
		if area.get_parent().is_in_group("enemy_bullets"):
			var bullet: RigidBody2D = area.get_parent()
			var damage: float = bullet.damage if remaining_health > bullet.damage else remaining_health
			remaining_health -= damage
			
			if damage != 0:
				$LifeBar.modulate.a = 1
			
			if remaining_health <= 0:
				die()
				$LifeBar.set_value(0)
			
			var new_bullet_damage = bullet.damage - damage
			area.get_parent().damage = new_bullet_damage
				
			if new_bullet_damage <= 0:
				area.get_parent().smooth_death_collision()
			
			if not is_dead:
				var new_health_value: float = $LifeBar.get_value() - 100 / health * damage
				$LifeBar.set_value(new_health_value)


func _on_skill_upgrade_menu_upgrade_damage(current_upgrade_level):
	bullet_damage = $UpgradesData.bullet_damage[current_upgrade_level]


func _on_skill_upgrade_menu_upgrade_bullet_speed(current_upgrade_level):
	bullet_speed = $UpgradesData.bullet_speed[current_upgrade_level]


func _on_skill_upgrade_menu_upgrade_reload(current_upgrade_level):
	reload_time = $UpgradesData.reload_time[current_upgrade_level]


func _on_skill_upgrade_menu_upgrade_precision(current_upgrade_level):
	precision_angle = $UpgradesData.precision_angle[current_upgrade_level]


func _on_skill_upgrade_menu_upgrade_player_speed(current_upgrade_level):
	player_speed = $UpgradesData.player_speed[current_upgrade_level]


func _on_skill_upgrade_menu_upgrade_health(current_upgrade_level):
	var prev_health: float = health
	health = $UpgradesData.health[current_upgrade_level]
	remaining_health += health - prev_health
	$LifeBar.set_value(remaining_health / health * 100)


func _on_skill_upgrade_menu_upgrade_regeneration(current_upgrade_level):
	regeneration = $UpgradesData.regeneration[current_upgrade_level]
