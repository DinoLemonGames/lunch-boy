extends TextureRect

const STARTING_MIN = 15
const STARTING_SEC = 0
var min = 0
var sec = 0

var timer_started = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Control starting the Watch timer
	if get_tree().current_scene.name == "JobCorpWarehouse" and !timer_started:
		timer_started = true
		min = STARTING_MIN
		sec = STARTING_SEC
		$SecTimer.start()
	elif get_tree().current_scene.name == "JobCorpWarehouse" and timer_started:
		$".".texture = load("res://textures/GUI/watch/watch_green.png")
		var second = "0" + str(sec)
		if sec < 10:
			$Label.text = str(min) + ":" + second
		else:
			$Label.text = str(min) + ":" + str(sec)
	elif get_tree().current_scene.name == "JobCorpOutside":
		$".".texture = load("res://textures/GUI/watch/watch.png")
		$Label.text = "ERR:"

func _on_sec_timer_timeout():
	if sec > 0:
		sec -= 1
	elif sec <= 0:
		min -= 1
		sec = 59
