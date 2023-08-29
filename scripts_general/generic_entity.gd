extends RigidBody2D

@export var life: int

@export var movement_speed: float = 2
@export var rotation_speed: float = 0.15

@export var smooth_spawn_time_sec: float = 0.1
var smooth_spawn_time_sec_current: float = 0
var smooth_spawn_complete: bool = false

@export var smooth_death_time_sec: float = 0.1
var smooth_death_time_sec_left: float = smooth_death_time_sec
var should_die: bool = false

# The time in seconds that the entity will take to periodically reset its random movement and
# rotation direction (if they aren't periodically reset, every entity will end up in
# a map's border after a while
@export var time_until_movement_change: float = 4
var time_until_movement_change_left: float = 0

var movement_direction: Vector2
var rotation_direction: float

func _ready():
	modulate.a = 0


func _process(delta):
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
	area.get_parent().queue_free()
	
	life -= 1
	
	if life <= 0:
		should_die = true
