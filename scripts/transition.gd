extends CanvasLayer

signal on_transition_finish

@onready var rect = $ColorRect
@onready var anim = $AnimationPlayer

var trans = false
var play_button = false

# Called when the node enters the scene tree for the first time.
func _ready():
	rect.visible = false

func transition():
	rect.visible = true
	anim.play("fade_to_black")

func _on_animation_player_animation_finished(anim_name):
	if trans == false:
		if anim_name == "fade_to_black":
			on_transition_finish.emit()
			trans = true
			anim.play_backwards("fade_to_black")
			if play_button:
				$CarDoorShut.play()
	else:
		rect.visible = false
		trans = false
