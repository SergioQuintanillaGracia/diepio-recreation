extends CharacterBody2D

signal shoot_bullet(pos, speed)

@export var speed: int = 500
@export var random_bullet_angle: float = 5

# Player upgradeable attributes:
@export var bullet_speed: int = 700

var can_shoot_bullet: bool = true


func _process(delta):
	# Movement and rotation
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	look_at(get_global_mouse_position())
	rotation_degrees += 90

	move_and_slide()
	
	
	if Input.is_action_pressed("primary") and can_shoot_bullet:
		# Send a signal with information about where to create the bullet, so it can be created inside level
		# Get the direction and random angle to shoot the bullet
		var random_choosen_angle = randf_range(-random_bullet_angle, random_bullet_angle)
		var shoot_angle: float = rad_to_deg((get_global_mouse_position() - position).angle()) + random_choosen_angle
		
		var shoot_direction: Vector2 = Vector2(cos(deg_to_rad(shoot_angle)), sin(deg_to_rad(shoot_angle)))
		var pos = $BulletMarkers/Marker1.global_position
		var bullet_speed_vector = shoot_direction * bullet_speed
		
		shoot_bullet.emit(pos, bullet_speed_vector)

		# Start the CanBulletTimer, when it goes off the player will be able to shoot again
		can_shoot_bullet = false
		$CanBulletTimer.start()


func _on_can_bullet_timer_timeout():
	can_shoot_bullet = true
