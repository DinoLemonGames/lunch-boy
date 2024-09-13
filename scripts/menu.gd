extends VBoxContainer

const JOBCORPOUTSIDE = preload("res://scenes/job_corp_outside.tscn")

func _on_play_pressed():
	$"../../PlayButtonSound".play()
	Transition.play_button = true
	Transition.transition()
	await Transition.on_transition_finish
	get_tree().change_scene_to_packed(JOBCORPOUTSIDE)

func _on_quit_to_desktop_pressed():
	get_tree().quit()

func _on_play_mouse_entered():
	$"../../HoverButtonSound".play()


func _on_options_mouse_entered():
	$"../../HoverButtonSound".play()


func _on_quit_to_desktop_mouse_entered():
	$"../../HoverButtonSound".play()
