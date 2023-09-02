extends RigidBody2D

@export var life: float
var remaining_life: float

@export var movement_speed: float = 2
@export var rotation_speed: float = 0.15

@export var smooth_spawn_time_sec: float = 0.12
var smooth_spawn_time_sec_current: float = 0
var smooth_spawn_complete: bool = false

@export var smooth_death_time_sec: float = 0.12
var smooth_death_time_sec_left: float = smooth_death_time_sec
var should_die: bool = false

# The time in seconds that the entity will take to periodically reset its random movement and
# rotation direction (if they aren't periodically reset, every entity will end up in
# a map's border after a while
@export var time_until_movement_change: float = 4
var time_until_movement_change_left: float = 0

var movement_direction: Vector2
var rotation_direction: float

var life_bar_scene: PackedScene = preload("res://scenes/guis/bars/life_bar.tscn")
var life_bar_position_offset: Vector2

func _ready():
	modulate.a = 0
	remaining_life = life
	life_bar_position_offset = $LifeBar.position
	$LifeBar.modulate.a = 0


func _process(delta):
	# Update the life_bar so it always stays where it should be
	$LifeBar.global_rotation = 0
	$LifeBar.global_position = global_position + life_bar_position_offset
	
	if not smooth_spawn_complete:
		smooth_spawn_time_sec_current += delta
		modulate.a = smooth_spawn_time_sec_current / smooth_spawn_time_sec
		
		if smooth_spawn_time_sec_current >= smooth_spawn_time_sec:
			smooth_spawn_complete = true
			modulate.a = 1
	
	if should_die:
		smooth_death_time_sec_left -= delta
		modulate.a = smooth_death_time_sec_left / smooth_death_time_sec
		
		if smooth_death_time_sec_left <= 0:
			queue_free()
	
	time_until_movement_change_left -= delta
	
	if time_until_movement_change_left <= 0:
		reset_random_movement()
		time_until_movement_change_left = time_until_movement_change
	
	set_linear_velocity(movement_direction * movement_speed)
	angular_velocity = rotation_direction * rotation_speed


func reset_random_movement():
	# Choose a random direction and rotation for the shape to move
	movement_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	rotation_direction = randf_range(-1, 1) * rotation_speed


func handle_collision(area: Area2D):
	if area.get_parent().is_in_group("player_bullets"):
		var bullet: RigidBody2D = area.get_parent()
		var damage: float = bullet.damage if remaining_life > bullet.damage else remaining_life
		remaining_life -= damage
		
		if damage != 0:
			$LifeBar.modulate.a = 1
		
		if remaining_life <= 0:
			should_die = true
			$LifeBar.set_value(0)
			
		var new_bullet_damage = bullet.damage - damage
		area.get_parent().damage = new_bullet_damage
			
		if new_bullet_damage <= 0:
			area.get_parent().smooth_death_collision()
		
		if not should_die:
			var new_life_value: float = $LifeBar.get_value() - 100 / life * damage
			$LifeBar.set_value(new_life_value)


func _on_area_2d_area_entered(area):
	handle_collision(area)
