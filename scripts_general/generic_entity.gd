extends RigidBody2D

@export var movement_speed: float = 2
@export var rotation_speed: float = 0.15

# The time in seconds that the entity will take to periodically reset its random movement and
# rotation direction (if they aren't periodically reset, every entity will end up in
# a map's border after a while
@export var time_until_movement_change: float = 4
var time_until_movement_change_left: float = 0

var movement_direction: Vector2
var rotation_direction: float


func _process(delta):
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
