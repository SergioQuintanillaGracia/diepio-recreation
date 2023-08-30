extends Control

signal upgrade_damage()
signal upgrade_bullet_speed()
signal upgrade_reload()


func _on_damage_upgrade_bar_upgrade_skill_button_pressed(progressbar):
	upgrade_damage.emit()
	add_progress_to_progressbar(progressbar)


func _on_bullet_speed_upgrade_bar_upgrade_skill_button_pressed(progressbar):
	upgrade_bullet_speed.emit()
	add_progress_to_progressbar(progressbar)


func _on_reload_upgrade_bar_upgrade_skill_button_pressed(progressbar):
	upgrade_reload.emit()
	add_progress_to_progressbar(progressbar)


func add_progress_to_progressbar(progressbar: TextureProgressBar):
	progressbar.value += 12.5
