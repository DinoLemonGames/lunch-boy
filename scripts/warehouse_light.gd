extends SpotLight3D

@onready var light = $"."
const LRANGE = 30.0
var player_in_light = false

# Turn the light off at the beginning of the game
func _ready():
	light.spot_range = 0.0

# Turn on the light when the player enters the Area3D
func _on_area_3d_body_entered(body):
	# Player Entered
	if body.is_in_group("player"):
		if !is_light_on():
			light_on()
		player_in_light = true
		
	# Object Entered
	elif body.is_in_group("light_motion"):
		if !is_light_on():
			light_on()
		$ObjectLightOffTimer.start()

# When the player exits the light's area start a timer
func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		player_in_light = false
		$LightOffTimer.start()

# Turn off the light after 5 sec
func _on_light_off_timer_timeout():
	# If an object hasn't entered the light
	if $ObjectLightOffTimer.is_stopped():
		light_off()

func _on_object_light_off_timer_timeout():
	if player_in_light == false:
		light_off()

func light_on():
	light.spot_range = LRANGE
	$LightOn.play()

func light_off():
	light.spot_range = 0.0
	$LightOff.play()

func is_light_on():
	if light.spot_range == LRANGE:
		return true
	elif light.spot_range == 0.0:
		return false
