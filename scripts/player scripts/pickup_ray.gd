extends RayCast3D

signal view_lock_change(_locked)

# Pickup variables
var picked_object
var pull_power = 5
var rotation_power = 0.2
var throw_power = 4
var locked = false
@onready var hand = $"../Hand"
@onready var interact_ray = $"."
@onready var joint = $"../Generic6DOFJoint3D"
@onready var staticbody = $"../StaticBody3D"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	# Pick up object
	if Input.is_action_just_pressed("lclick"):
		if picked_object == null:
			pick_object()
		elif picked_object != null:
			drop_object()
	
	# Rotate object
	if Input.is_action_pressed("rclick"):
		if picked_object != null:
			locked = true
			view_lock_change.emit(locked)
			rotate_object(event)
	if Input.is_action_just_released("rclick"):
		locked = false
		view_lock_change.emit(locked)
	
	# Throw object
	if Input.is_action_just_pressed("throw"):
		if picked_object != null:
			locked = false
			view_lock_change.emit(locked)
			var knockback = picked_object.global_position - global_position
			picked_object.apply_central_impulse(knockback * throw_power)
			drop_object()

func _physics_process(delta):
	# Move the picked object so it follows the players view
	if picked_object != null:
		var object_origin = picked_object.global_transform.origin
		var hand_origin = hand.global_transform.origin
		picked_object.set_linear_velocity((hand_origin - object_origin) * pull_power)

func pick_object():
	# Check to see if raycast is colliding
	var collider = interact_ray.get_collider()
	# If it's colliding with a rigidbody
	if collider != null and collider is RigidBody3D:
		picked_object = collider
		joint.set_node_b(picked_object.get_path())

func drop_object():
	if picked_object != null:
		picked_object = null
		joint.set_node_b(joint.get_path())

func rotate_object(event):
	if picked_object != null:
		if event is InputEventMouseMotion:
			staticbody.rotate_x(deg_to_rad(event.relative.y * rotation_power))
			staticbody.rotate_y(deg_to_rad(event.relative.x * rotation_power))
