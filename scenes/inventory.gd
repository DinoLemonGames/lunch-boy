extends TextureRect

enum inv_state {
	HELD,
	STORED,
	EMPTY
}

var inv = []
var inv_slots = 4
var inv_height = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	# This creates the 2D array for the inventory from inv[0][0] to inv[3][1]
	for i in inv_slots:
		inv.append([])
		for j in inv_height:
			inv[i].append("0")
	
	# Set the default values
	inv[0][0] = inv_state.HELD
	inv[1][0] = inv_state.EMPTY
	inv[2][0] = inv_state.EMPTY
	inv[3][0] = inv_state.EMPTY
	
	inv[1][1] = "res://textures/inventory/box_inventory_texture_128.png"
	inv[2][1] = "res://textures/inventory/chipbag_inventory_texture_128.png"
	inv[3][1] = "res://textures/inventory/lemonade_inventory_texture_128.png"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inv[0][0] == inv_state.HELD:
		visible = false
	elif inv[1][0] == inv_state.HELD:
		if inv[1][1] != "0":
			visible = true
			texture = load(inv[1][1])
	elif inv[2][0] == inv_state.HELD:
		if inv[2][1] != "0":
			visible = true
			texture = load(inv[2][1])
	elif inv[3][0] == inv_state.HELD:
		if inv[3][1] != "0":
			visible = true
			texture = load(inv[3][1])

func _input(event):
	if Input.is_action_just_pressed("inv_1"):
		for i in inv_slots:
			inv[i][0] = inv_state.STORED
		inv[0][0] = inv_state.HELD
	if Input.is_action_just_pressed("inv_2"):
		for i in inv_slots:
			inv[i][0] = inv_state.STORED
		inv[1][0] = inv_state.HELD
	if Input.is_action_just_pressed("inv_3"):
		for i in inv_slots:
			inv[i][0] = inv_state.STORED
		inv[2][0] = inv_state.HELD
	if Input.is_action_just_pressed("inv_4"):
		for i in inv_slots:
			inv[i][0] = inv_state.STORED
		inv[3][0] = inv_state.HELD
