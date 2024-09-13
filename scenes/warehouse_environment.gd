extends WorldEnvironment


# Called when the node enters the scene tree for the first time.
func _ready():
	environment.volumetric_fog_enabled = true
	environment.fog_enabled = true
	$"../OUTSIDE WALLS/Roof".visible = true
	$"../LIGHTS/LeftRow".visible = true
	$"../LIGHTS/MiddleRow".visible = true
	$"../LIGHTS/RightRow".visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
