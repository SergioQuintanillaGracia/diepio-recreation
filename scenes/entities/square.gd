extends RigidBody2D

var movement_direction: Vector2
var rotation_direction: float
@export var movement_speed: float = 2
@export var rotation_speed: float = 0.3

func _ready():
	# Choose a random direction for the shape to move
	movement_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	rotation_direction = randf_range(-1, 1) * rotation_speed


func _process(delta):
	set_linear_velocity(movement_direction * movement_speed)
	angular_velocity = rotation_direction * rotation_speed
