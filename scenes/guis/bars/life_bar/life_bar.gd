extends Node2D


func set_value(new_value: float):
	$TextureProgressBar.value = new_value


func get_value() -> float:
	return $TextureProgressBar.value
