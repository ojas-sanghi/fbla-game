extends Control

func _ready() -> void:
	# Focus on the Quit button on start
	$VBoxContainer/QuitMenu.grab_focus()

func _on_QuitMenu_pressed() -> void:
	# Once the Quit button is pressed, fade in and go back to the main menu.
	$AnimationPlayer.play("fade_in")
	yield($AnimationPlayer, "animation_finished")

	get_tree().change_scene("res://assets/GUI/screens/TitleScreen.tscn")
