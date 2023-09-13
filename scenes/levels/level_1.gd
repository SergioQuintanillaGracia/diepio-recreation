extends Node2D


var player_bullet_normal_scene: PackedScene = preload("res://scenes/bullets/player_bullet_normal.tscn")
var enemy_bullet_normal_scene: PackedScene = preload("res://scenes/bullets/enemy_bullet_normal.tscn")


func _on_player_shoot_bullet(pos, speed_vector, speed, damage):
	var bullet = player_bullet_normal_scene.instantiate() as RigidBody2D
	bullet.position = pos
	bullet.linear_velocity = speed_vector
	bullet.damage = damage
	bullet.speed = speed
	$"../Bullets".add_child(bullet)


func enemy_shoot_bullet(pos, speed_vector, speed, damage):
	# Create a bullet, give it a position and a speed, and add it to the Bullets node
	var bullet = enemy_bullet_normal_scene.instantiate() as RigidBody2D
	bullet.position = pos
	bullet.linear_velocity = speed_vector
	bullet.damage = damage
	bullet.speed = speed
	$"../Bullets".add_child(bullet)


func _on_enemy_tank_shoot_bullet(pos, speed_vector, speed, damage):
	enemy_shoot_bullet(pos, speed_vector, speed, damage)
