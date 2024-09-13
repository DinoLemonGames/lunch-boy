extends SpotLight3D

@onready var light = $"."
const LRANGE = 30.0

# Turn the light off at the beginning of the game
func _ready():
	light.spot_range = 0.0

# Turn on the light when the player enters the Area3D
func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		# Light ON
		light.spot_range = LRANGE
		$LightOn.play()

# When the player exits the light's area start a timer
func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		$LightOffTimer.start()

# Turn off the light after 5 sec
func _on_light_off_timer_timeout():
	# Light OFF
	light.spot_range = 0.0
	$LightOff.play()
