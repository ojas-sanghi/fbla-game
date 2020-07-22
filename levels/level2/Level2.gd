extends Node2D

export var right_limit = 0
export var bottom_limit = 0

func _ready() -> void:
	# Set camera limit to the position of the last tile in the level
	$Player/Camera2D.limit_right = right_limit
	$Player/Camera2D.limit_bottom = bottom_limit
