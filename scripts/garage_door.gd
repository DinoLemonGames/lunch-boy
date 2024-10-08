extends Node3D

@onready var follow1 = $Path3D/Follow1
@onready var follow2 = $Path3D/Follow2
@onready var follow3 = $Path3D/Follow3
@onready var follow4 = $Path3D/Follow4

# Sounds
@onready var door_shut = $DoorShut
@onready var door_open = $DoorOpen

var follow1_start
var follow2_start
var follow3_start
var follow4_start

var state
enum States {
	OPENING,
	CLOSING,
	OPEN,
	CLOSED
}

const SPEED = 0.002

# Called when the node enters the scene tree for the first time.
func _ready():
	state = States.CLOSED
	follow1_start = follow1.progress_ratio # Bottom = 1-(4)
	follow2_start = follow2.progress_ratio # = 1-(3)
	follow3_start = follow3.progress_ratio # = 1-(2)
	follow4_start = follow4.progress_ratio # Top = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == States.OPENING:
		follow1.progress_ratio = lerp(follow1.progress_ratio, 1-follow4_start, SPEED)
		follow2.progress_ratio = lerp(follow2.progress_ratio, 1-follow3_start, SPEED)
		follow3.progress_ratio = lerp(follow3.progress_ratio, 1-follow2_start, SPEED)
		follow4.progress_ratio = lerp(follow4.progress_ratio, 1.0, SPEED)
		if follow4.progress_ratio > .98:
			state = States.OPEN
	if state == States.CLOSING:
		if follow1.progress_ratio > 0.0158:
			follow1.progress_ratio = lerp(follow1.progress_ratio, follow1_start, SPEED)
			follow2.progress_ratio = lerp(follow2.progress_ratio, follow2_start, SPEED)
			follow3.progress_ratio = lerp(follow3.progress_ratio, follow3_start, SPEED)
			follow4.progress_ratio = lerp(follow4.progress_ratio, follow4_start, SPEED)
		elif follow1.progress_ratio < 0.0158 and follow1.progress_ratio > 0.01:
			follow1.progress_ratio = lerp(follow1.progress_ratio, follow1_start, SPEED*10)
			follow2.progress_ratio = lerp(follow2.progress_ratio, follow2_start, SPEED*10)
			follow3.progress_ratio = lerp(follow3.progress_ratio, follow3_start, SPEED*10)
			follow4.progress_ratio = lerp(follow4.progress_ratio, follow4_start, SPEED*10)
		elif follow1.progress_ratio < 0.01:
			state = States.CLOSED

func _on_garage_button_interacted(body):
	if state == States.CLOSED:
		door_open.play()
		state = States.OPENING
	elif state == States.OPEN:
		door_shut.play()
		state = States.CLOSING
