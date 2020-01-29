extends Control

func _ready() -> void:
	# Set camera limit to the position of the last tile in the level
	$Player/Camera2D.limit_right = 1920
