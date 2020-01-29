extends Control

func _ready() -> void:
	$VBoxContainer/QuitMenu.grab_focus()

func _on_QuitMenu_pressed() -> void:
	$AnimationPlayer.play("fade_in")
	yield($AnimationPlayer, "animation_finished")

	get_tree().change_scene("res://assets/GUI/screens/TitleScreen.tscn")
