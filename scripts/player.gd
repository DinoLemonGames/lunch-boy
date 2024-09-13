extends CharacterBody3D

var speed
const WALK_SPEED = 4.0
const SPRINT_SPEED = 6.0
const JUMP_VELOCITY = 4.5

var sensitivity = 0.003

# Head Bob Variables
# How often
const BOB_FREQ = 2.5
# How far up and down
const BOB_AMP = 0.1
# How far along the sine function we're along
var t_bob = 0.0

# FOV variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

@onready var head = $Head
@onready var camera = $Head/Camera3D

# Audio
@onready var sn_walking = $AudioWalking
@onready var sn_walking_pants = $AudioWalkingPants
var played_pants = false
var played_walking = false
var landed = false
@onready var sn_running = $AudioRunning

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	# Mouse Handling (temporary until menu is added)
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Mouse Movement
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		# Gravity in settings is 9.8
		velocity += get_gravity() * delta
		landed = false

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		sn_walking_pants.play()
		velocity.y = JUMP_VELOCITY
	
	# Handle Sprinting
	if Input.is_action_pressed("sprint") and is_on_floor():
		speed = SPRINT_SPEED
		# Make hunger go down faster
		$Head/Camera3D/Stomach/TummyTimer.wait_time = 0.5
	else:
		speed = WALK_SPEED
		$Head/Camera3D/Stomach/TummyTimer.wait_time = 2.5
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if !landed:
			sn_walking.play()
			landed = true
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	# Head Bob
	#        time   Vary how fast moving  Make sure the player is on the floor
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	# Walking Audio
	if speed == WALK_SPEED:
		if pos.y < -0.099:
			if !sn_walking.playing and !played_walking:
				sn_walking.play()
				played_walking = true
				played_pants = false
		if pos.y > 0.099:
			#if !sn_walking_pants.playing and !played_pants:
			sn_walking_pants.play()
			played_pants = true
			played_walking = false
	# Running Audio
	elif speed == SPRINT_SPEED:
		if pos.y < -0.099:
			sn_running.play()
		if pos.y > 0.099:
			sn_walking_pants.play()
	
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func _on_doorway_body_entered(body):
	if body.is_in_group("player"):
		get_tree().call_deferred("change_scene_to_file", "res://scenes/job_corp_warehouse.tscn")
