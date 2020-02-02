extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		togglePause()

func togglePause() -> void:
	# Set the paused and visible status to the opposite of what they currently are
	get_tree().paused = not get_tree().paused
	visible = not visible

	$VBoxContainer/Resume.grab_focus()

func _on_Resume_pressed() -> void:
	togglePause()

func _on_QuitMenu_pressed() -> void:
	# Once the Quit button is pressed, fade in
	$AnimationPlayer.play("fade_in")
	yield($AnimationPlayer, "animation_finished")

	# Unpause
	get_tree().paused = false
	visible = false

	# Go back to the main menu
	get_tree().change_scene("res://assets/GUI/screens/TitleScreen.tscn")

func _on_QuitDesktop_pressed() -> void:
	get_tree().quit()
