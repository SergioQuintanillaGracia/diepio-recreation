extends CharacterBody2D

signal shoot_bullet(pos, speed, damage)

@export var player_name: String
@export var speed: int = 500
@export var random_bullet_angle: float = 5

@export var default_bullet_damage: float
@export var default_bullet_speed: float
@export var default_reload_time: float

# Player upgradeable attributes:
var bullet_damage: float
var bullet_speed: float
var reload_time: float

var reload_time_left: float

var can_shoot_bullet: bool = true
var is_autofire_enabled: bool = false


func _ready():
	bullet_speed = default_bullet_speed
	bullet_damage = default_bullet_damage
	reload_time = default_reload_time
	
	reload_time_left = reload_time


func _process(delta):
	reload_time_left -= delta
	
	# Movement and rotation
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	look_at(get_global_mouse_position())
	rotation_degrees += 90

	move_and_slide()
	
	# Handle player input:
	if (Input.is_action_pressed("primary") or is_autofire_enabled) and reload_time_left < 0:
		# Send a signal with information about where to create the bullet, so it can be created inside level
		# Get the direction and random angle to shoot the bullet
		var random_choosen_angle = randf_range(-random_bullet_angle, random_bullet_angle)
		var shoot_angle: float = rad_to_deg((get_global_mouse_position() - position).angle()) + random_choosen_angle
		
		var shoot_direction: Vector2 = Vector2(cos(deg_to_rad(shoot_angle)), sin(deg_to_rad(shoot_angle)))
		var pos = $BulletMarkers/Marker1.global_position
		var bullet_speed_vector = shoot_direction * bullet_speed
		
		shoot_bullet.emit(pos, bullet_speed_vector, bullet_speed, bullet_damage)

		can_shoot_bullet = false
		reload_time_left = reload_time
		
	if (Input.is_action_just_pressed("autofire")):
		is_autofire_enabled = false if is_autofire_enabled else true
