extends Node2D

func _ready():
	# Set camera limit to the position of the last tile in the level
	$Player/Camera2D.limit_right = 6272
