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


var can_shoot_bullet: bool = true
var is_autofire_enabled: bool = false


func _ready():
	reload_time = default_reload_time
	bullet_damage = default_bullet_damage
	reload_time = default_reload_time
	
	# TODO: Transform the CanBulletTimer into code, it will be better to control it that way, by only changing the reload_time whenever reload is upgraded
	set_reload_time(reload_time)


func _process(_delta):
	# Movement and rotation
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	look_at(get_global_mouse_position())
	rotation_degrees += 90

	move_and_slide()
	
	
	if (Input.is_action_pressed("primary") or is_autofire_enabled) and can_shoot_bullet:
		# Send a signal with information about where to create the bullet, so it can be created inside level
		# Get the direction and random angle to shoot the bullet
		var random_choosen_angle = randf_range(-random_bullet_angle, random_bullet_angle)
		var shoot_angle: float = rad_to_deg((get_global_mouse_position() - position).angle()) + random_choosen_angle
		
		var shoot_direction: Vector2 = Vector2(cos(deg_to_rad(shoot_angle)), sin(deg_to_rad(shoot_angle)))
		var pos = $BulletMarkers/Marker1.global_position
		var bullet_speed_vector = shoot_direction * default_bullet_speed
		
		shoot_bullet.emit(pos, bullet_speed_vector, bullet_damage)

		# Start the CanBulletTimer, when it goes off the player will be able to shoot again
		can_shoot_bullet = false
		$CanBulletTimer.start()
		
	if (Input.is_action_just_pressed("autofire")):
		is_autofire_enabled = false if is_autofire_enabled else true


func set_reload_time(new_reload_time):
	$CanBulletTimer.wait_time = new_reload_time


func _on_can_bullet_timer_timeout():
	can_shoot_bullet = true
