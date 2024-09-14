extends RayCast3D

# Interaction Variables
@onready var prompt = $Prompt

func _physics_process(delta):
	# Interaction
	prompt.text = ""
	
	if is_colliding():
		var collider = get_collider()  
		
		if collider is Interactable:
			prompt.text = collider.get_prompt()
			
			if Input.is_action_just_pressed(collider.prompt_input):
				# Emit signal of what you want the butotn to do here
				collider.interact(owner)
