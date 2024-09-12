extends SubViewportContainer

@onready var viewport = $SubViewport

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Set the viewport for the post processing to the same size as the window
	viewport.size = get_viewport().get_visible_rect().size
