extends "res://scripts_general/generic_entity.gd"


func _on_area_2d_area_entered(area):
	handle_collision(area)
	
	if should_die:
		$Area2D.queue_free()
