extends Node3D

@onready var follow1 = $Path3D/Follow1
@onready var follow2 = $Path3D/Follow2
@onready var follow3 = $Path3D/Follow3
@onready var follow4 = $Path3D/Follow4

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

const SPEED = 0.005

func _input(event):
	if Input.is_action_just_pressed("debug_1"):
		if state == States.CLOSED or state == States.CLOSING:
			state = States.OPENING
		elif state == States.OPEN or state == States.OPENING:
			state = States.CLOSING

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
		follow1.progress_ratio = lerp(follow1.progress_ratio, follow1_start, SPEED)
		follow2.progress_ratio = lerp(follow2.progress_ratio, follow2_start, SPEED)
		follow3.progress_ratio = lerp(follow3.progress_ratio, follow3_start, SPEED)
		follow4.progress_ratio = lerp(follow4.progress_ratio, follow4_start, SPEED)
		if follow1.progress_ratio < 0.006:
			state = States.CLOSED
