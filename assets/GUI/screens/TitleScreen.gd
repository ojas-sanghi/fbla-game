extends Control

func _ready() -> void:
	# Focus on the Play button on start
	$VBoxContainer/Play.grab_focus()

func _on_Play_pressed() -> void:
	# Fade in, and go to Level1
	$AnimationPlayer.play("fade_in")
	yield($AnimationPlayer, "animation_finished")

	get_tree().change_scene("res://levels/level1/Level1.tscn")

func _on_QuitDesktop_pressed() -> void:
	get_tree().quit()
