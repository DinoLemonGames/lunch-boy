extends TextureProgressBar

const FULL = 100
var timer_started = false

func _ready():
	max_value = FULL
	value = FULL

func _process(delta):
	$PercentLabel.text = str(value) + "%"
	# Control starting the Tummy timer
	if get_tree().current_scene.name == "JobCorpWarehouse" and !timer_started:
		timer_started = true
		$TummyTimer.start()

func _on_tummy_timer_timeout():
	value -= 1
