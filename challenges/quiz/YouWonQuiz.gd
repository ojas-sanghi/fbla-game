extends Control

func _ready() -> void:
	$Player/Camera2D.limit_right = 1920
	Globals.add_powerup("double_jump")