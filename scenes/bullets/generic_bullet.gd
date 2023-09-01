extends RigidBody2D

# The damage should be set just after instantiating the scene
var damage: float
var speed: float

var life_time_sec: float
var smooth_death_time_sec: float

# When a player shoots the bullet, the shooter variable will be set to the player node
# var shooter: CharacterBody2D # TEMPORARY DISABLED, PROBABLY NOT NECESSARY

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
		damage = 0
		$SmoothDeathTimer.start()


func smooth_death_collision():
	linear_damp = speed / 700 * 30
	smooth_death()


func _on_life_timer_timeout():
	smooth_death()


func _on_smooth_death_timer_timeout():
	queue_free()
