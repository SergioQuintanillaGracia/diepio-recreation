extends Control

var old_progressbar_value: float
var new_progressbar_value: float
var smooth_set_time: float


func _ready():
	smooth_set_time = $SmoothSetTimer.wait_time


func _process(_delta):
	$TextureProgressBar.value = old_progressbar_value + (new_progressbar_value - old_progressbar_value) * (1.0 - ($SmoothSetTimer.time_left / smooth_set_time))


func set_information(level, current_points, previous_level_points, next_level_points):
	if next_level_points != null:
		var next_level_points_show: int = next_level_points - previous_level_points
		var current_points_show: int = current_points - previous_level_points
		$Label.text = "Level " + str(level) + " (" + str(current_points_show) + " / " + str(next_level_points_show) + ")"
		smooth_set_value(current_points_show / float(next_level_points_show) * 100)
		
	else:
		# The player is at max level, because next_level_points is null.
		$Label.text = "Level " + str(level) + " (MAX)"
		smooth_set_value(100)


func smooth_set_value(new_value):
	$SmoothSetTimer.stop()
	$SmoothSetTimer.start()
	old_progressbar_value = $TextureProgressBar.value
	new_progressbar_value = new_value
