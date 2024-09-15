extends Interactable

@onready var anim = $AnimationPlayer

func _on_interacted(body):
	anim.play("button_pushed")
