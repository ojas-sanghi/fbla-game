extends Control

func _ready() -> void:
	$VBoxContainer/Play.grab_focus()

func _on_Play_pressed() -> void:
	$AnimationPlayer.play("fade_in")
	yield($AnimationPlayer, "animation_finished")

	get_tree().change_scene("res://levels/level1/Level1.tscn")

func _on_QuitDesktop_pressed() -> void:
	get_tree().quit()