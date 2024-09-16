extends TextureRect

signal on_clocked_in

const STARTING_MIN = 15
const STARTING_SEC = 0
var min = STARTING_MIN
var sec = STARTING_SEC

var timer_started = false
enum clock {
	IN,
	OUT,
	BREAK
}
var state = clock.OUT

var green = Color("#16f046")
var red = Color("#fc575f")
var yellow = Color("#fee441")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if state == clock.IN:
		# Count down the shift time
		var second = "0" + str(sec)
		if sec < 10:
			$Label.text = str(min) + ":" + second
		else:
			$Label.text = str(min) + ":" + str(sec)
	elif state == clock.OUT:
		$Label.text = "OUT"
		$Label.self_modulate = red
		texture = load("res://textures/GUI/watch/watch_red.png")
	
	if get_tree().current_scene.name == "JobCorpOutside":
		texture = load("res://textures/GUI/watch/watch.png")
		$Label.text = "ERR:"

func _on_sec_timer_timeout():
	if sec > 0:
		sec -= 1
	elif sec <= 0:
		min -= 1
		sec = 59

func _on_player_clocked_in():
	if state != clock.IN:
		$SecTimer.start()
		$Label.self_modulate = green 
		texture = load("res://textures/GUI/watch/watch_green.png")
		state = clock.IN

func _on_player_clocked_break():
	if state == clock.IN:
		$SecTimer.stop()
		$Label.self_modulate = yellow
		texture = load("res://textures/GUI/watch/watch_yellow.png")
		state = clock.BREAK

func _on_player_clocked_out():
	if state == clock.IN:
		$SecTimer.stop()
		texture = load("res://textures/GUI/watch/watch_red.png")
		state = clock.OUT
