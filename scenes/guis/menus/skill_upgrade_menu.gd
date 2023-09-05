extends Control

signal upgrade_damage(current_upgrade_level: int)
signal upgrade_bullet_speed(current_upgrade_level: int)
signal upgrade_reload(current_upgrade_level: int)
signal upgrade_precision(current_upgrade_level: int)
signal upgrade_health(current_upgrade_level: int)
signal upgrade_regeneration(current_upgrade_level: int)
signal upgrade_player_speed(current_upgrade_level: int)


var skill_points = 0


func set_level_information(level, current_points, previous_level_points, points_to_next_level):
	$LevelBar.set_information(level, current_points, previous_level_points, points_to_next_level)


func get_skill_points():
	return skill_points


func set_skill_points(points):
	skill_points = points
	$SkillPoints/Label.text = "Available Skill Points: " + str(skill_points)


func _on_damage_upgrade_bar_upgrade_skill_button_pressed(progressbar):
	upgrade_skill(progressbar, upgrade_damage, $DamageUpgradeBar)


func _on_bullet_speed_upgrade_bar_upgrade_skill_button_pressed(progressbar):
	upgrade_skill(progressbar, upgrade_bullet_speed, $BulletSpeedUpgradeBar)


func _on_reload_upgrade_bar_upgrade_skill_button_pressed(progressbar):
	upgrade_skill(progressbar, upgrade_reload, $ReloadUpgradeBar)


func _on_precision_upgrade_bar_upgrade_skill_button_pressed(progressbar):
	upgrade_skill(progressbar, upgrade_precision, $PrecisionUpgradeBar)
	
	
func _on_player_speed_upgrade_bar_upgrade_skill_button_pressed(progressbar):
	upgrade_skill(progressbar, upgrade_player_speed, $PlayerSpeedUpgradeBar)


func _on_health_upgrade_bar_upgrade_skill_button_pressed(progressbar):
	upgrade_skill(progressbar, upgrade_health, $HealthUpgradeBar)


func _on_regeneration_upgrade_bar_upgrade_skill_button_pressed(progressbar):
	upgrade_skill(progressbar, upgrade_regeneration, $RegenerationUpgradeBar)


func add_progress_to_progressbar(progressbar: TextureProgressBar):
	progressbar.value += 12.5


func upgrade_skill(progressbar: TextureProgressBar, signal_to_send: Signal, bar_node: Control):
	if skill_points > 0 and progressbar.value < 100:
		add_progress_to_progressbar(progressbar)
		signal_to_send.emit(bar_node.get_current_upgrade_level())
		set_skill_points(get_skill_points() - 1)
