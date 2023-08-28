extends Node2D

var bullet_normal_scene: PackedScene = preload("res://scenes/bullets/bullet_normal.tscn")

func _on_player_shoot_bullet(pos, speed):
	var bullet = bullet_normal_scene.instantiate() as RigidBody2D
	bullet.position = pos
	bullet.linear_velocity = speed
	$Bullets.add_child(bullet)
