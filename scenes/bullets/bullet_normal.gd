extends RigidBody2D

var life_time_sec: float
var smooth_death_time_sec: float

# When a player shoots the bullet, the shooter variable will be set to the player node
var shooter: CharacterBody2D

func _ready():
	life_time_sec = $LifeTimer.wait_time
	smooth_death_time_sec = $SmoothDeathTimer.wait_time
	$LifeTimer.start()


func _process(_delta):
	if not $SmoothDeathTimer.is_stopped():
		var time_left: float = $SmoothDeathTimer.time_left
		var new_opacity: float = time_left / smooth_death_time_sec
		modulate.a = new_opacity


func smooth_death():
	if $SmoothDeathTimer.is_stopped():
		$SmoothDeathTimer.start()


func _on_life_timer_timeout():
	smooth_death()


func _on_smooth_death_timer_timeout():
	queue_free()
