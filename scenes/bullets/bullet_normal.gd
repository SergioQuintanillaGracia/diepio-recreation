extends RigidBody2D

@export var life_time_sec: float = 3
@export var smooth_death_time_sec: float = 0.5

func _ready():
	$LifeTimer.wait_time = life_time_sec
	$LifeTimer.start()


func _process(delta):
	if not $SmoothDeathTimer.is_stopped():
		var time_left: float = $SmoothDeathTimer.time_left
		var new_opacity: float = time_left / smooth_death_time_sec
		modulate.a = new_opacity


func _on_life_timer_timeout():
	$SmoothDeathTimer.start()


func _on_smooth_death_timer_timeout():
	queue_free()
