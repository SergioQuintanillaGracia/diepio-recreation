extends Control

signal upgrade_skill_button_pressed(progressbar: TextureProgressBar)


func _on_texture_button_pressed():
	upgrade_skill_button_pressed.emit($TextureProgressBar)
