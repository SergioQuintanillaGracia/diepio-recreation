extends CharacterBody2D

signal shoot_bullet(pos, speed_vector, speed, damage)

@export var random_bullet_angle: float
@export var health: float
@export var speed: int
@export var bullet_damage: float
@export var bullet_speed: float
@export var reload_time: float

@export var minimum_distance_to_player: float
@export var vision_range: float

var remaining_health: float
var reload_time_left: float
var can_shoot_bullet: bool = true

var life_bar_position_offset: Vector2

# The player position should be modified from the level scene, inside _process()
var player_position: Vector2


func _ready():
	remaining_health = health
	life_bar_position_offset = $LifeBar.position
	$LifeBar.modulate.a = 1


func _process(delta):
	reload_time_left -= delta
	
	# Movement and rotation
	var vector_distance_to_player: Vector2 = player_position - global_position
	var distance_to_player: float = sqrt(vector_distance_to_player[0]**2 + vector_distance_to_player[1]**2)
	var direction: Vector2 = (player_position - global_position).normalized()
	velocity = direction * speed if distance_to_player > minimum_distance_to_player and distance_to_player < vision_range else Vector2(0, 0)
	
	
	if distance_to_player < vision_range:
		look_at(player_position)
		rotation_degrees += 90
		move_and_slide()
	
	# Update the life_bar so it always stays where it should be
	$LifeBar.global_rotation = 0
	$LifeBar.global_position = global_position + life_bar_position_offset
	
	# Handle player input:
	if reload_time_left < 0 and distance_to_player < vision_range:
		# Send a signal with information about where to create the bullet, so it can be created inside level
		# Get the direction and random angle to shoot the bullet
		for marker in $BulletMarkers.get_children():
			var random_choosen_angle = randf_range(-random_bullet_angle, random_bullet_angle)
			var shoot_angle: float = rad_to_deg((player_position - position).angle()) + random_choosen_angle + marker.rotation_degrees
			
			var shoot_direction: Vector2 = Vector2(cos(deg_to_rad(shoot_angle)), sin(deg_to_rad(shoot_angle)))
			var pos = marker.global_position
			var bullet_speed_vector = shoot_direction * bullet_speed
			
			shoot_bullet.emit(pos, bullet_speed_vector, bullet_speed, bullet_damage)

			can_shoot_bullet = false
			reload_time_left = reload_time
