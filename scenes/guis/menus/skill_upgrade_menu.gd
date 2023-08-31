extends Control

signal upgrade_damage(current_upgrade_level: int)
signal upgrade_bullet_speed(current_upgrade_level: int)
signal upgrade_reload(current_upgrade_level: int)


func _on_damage_upgrade_bar_upgrade_skill_button_pressed(progressbar):
	add_progress_to_progressbar(progressbar)
	upgrade_damage.emit($DamageUpgradeBar.get_current_upgrade_level())


func _on_bullet_speed_upgrade_bar_upgrade_skill_button_pressed(progressbar):
	add_progress_to_progressbar(progressbar)
	upgrade_bullet_speed.emit($BulletSpeedUpgradeBar.get_current_upgrade_level())


func _on_reload_upgrade_bar_upgrade_skill_button_pressed(progressbar):
	add_progress_to_progressbar(progressbar)
	upgrade_reload.emit($ReloadUpgradeBar.get_current_upgrade_level())


func add_progress_to_progressbar(progressbar: TextureProgressBar):
	progressbar.value += 12.5
