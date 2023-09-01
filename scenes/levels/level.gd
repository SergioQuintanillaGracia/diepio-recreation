extends Node2D

var player_bullet_normal_scene: PackedScene = preload("res://scenes/bullets/player_bullet_normal.tscn")
var enemy_bullet_normal_scene: PackedScene = preload("res://scenes/bullets/enemy_bullet_normal.tscn")

var square_scene: PackedScene = preload("res://scenes/entities/square.tscn")
var triangle_scene: PackedScene = preload("res://scenes/entities/triangle.tscn")
var pentagon_scene: PackedScene = preload("res://scenes/entities/pentagon.tscn")

@export var time_between_entity_spawns_sec: float
@export var entity_limit: int

# The time in seconds between different entity types spawns
@export var square_chance: float
@export var triangle_chance: float
@export var pentagon_chance: float

# Entities will spawn inside these limits. The Marker2Ds should be set inside the inspector.
@export var spawn_limit_1: Marker2D
@export var spawn_limit_2: Marker2D

@export var zoom_limit: float = 1.5
@export var unzoom_limit: float = 0.5

var zoom_limit_vector: Vector2
var unzoom_limit_vector: Vector2

var time_since_last_entity: float


func _ready():
	zoom_limit_vector = Vector2(zoom_limit, zoom_limit)
	unzoom_limit_vector = Vector2(unzoom_limit, unzoom_limit)


func _process(delta):	
	time_since_last_entity += delta
	
	var entity_count = $Entities.get_child_count()
	
	if time_since_last_entity >= time_between_entity_spawns_sec and entity_count < entity_limit:
		spawn_random_shape()
		time_since_last_entity = 0
	
	var current_camera_zoom: Vector2 = $Player/Camera2D.zoom
	
	if Input.is_action_just_pressed("zoom"):
		var new_zoom_vector: Vector2 = current_camera_zoom * 1.1
		$Player/Camera2D.zoom = new_zoom_vector if new_zoom_vector < zoom_limit_vector else zoom_limit_vector
		
	if Input.is_action_just_pressed("unzoom"):
		var new_zoom_vector: Vector2 = current_camera_zoom * 0.9
		$Player/Camera2D.zoom = new_zoom_vector if new_zoom_vector > unzoom_limit_vector else unzoom_limit_vector
		
	# Handle enemies:
	for enemy in $Enemies.get_children():
		enemy.player_position = $Player.global_position


func _on_tank_shoot_bullet(pos, speed_vector, speed, damage):
	# Create a bullet, give it a position and a speed, and add it to the Bullets node
	var bullet = player_bullet_normal_scene.instantiate() as RigidBody2D
	bullet.position = pos
	bullet.linear_velocity = speed_vector
	bullet.damage = damage
	bullet.speed = speed
	$Bullets.add_child(bullet)


func _on_enemy_tank_shoot_bullet(pos, speed_vector, speed, damage):
	enemy_shoot_bullet(pos, speed_vector, speed, damage)


func enemy_shoot_bullet(pos, speed_vector, speed, damage):
	# Create a bullet, give it a position and a speed, and add it to the Bullets node
	var bullet = enemy_bullet_normal_scene.instantiate() as RigidBody2D
	bullet.position = pos
	bullet.linear_velocity = speed_vector
	bullet.damage = damage
	bullet.speed = speed
	$Bullets.add_child(bullet)


func get_random_pos() -> Vector2:
	var random_x: float = randf_range(spawn_limit_1.global_position[0], spawn_limit_2.global_position[0])
	var random_y: float = randf_range(spawn_limit_1.global_position[1], spawn_limit_2.global_position[1])
	
	return Vector2(random_x, random_y)
	
	
func spawn_random_shape() -> void:
	var random_value: float = randf_range(0, 1)
	
	if random_value < square_chance:
		spawn_shape(square_scene, get_random_pos())
	elif random_value < square_chance + triangle_chance:
		spawn_shape(triangle_scene, get_random_pos())
	else:
		spawn_shape(pentagon_scene, get_random_pos())

	spawn_shape(square_scene, get_random_pos())


func spawn_shape(shape_scene: PackedScene, pos: Vector2) -> void:
	var shape: RigidBody2D = shape_scene.instantiate() as RigidBody2D
	shape.global_position = pos
	$Entities.add_child(shape)

