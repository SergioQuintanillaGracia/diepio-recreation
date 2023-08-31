extends Control

signal upgrade_skill_button_pressed(progressbar: TextureProgressBar)

func get_current_upgrade_level():
	return int($TextureProgressBar.value / 12.5)


func _on_texture_button_pressed():
	upgrade_skill_button_pressed.emit($TextureProgressBar)
