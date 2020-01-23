extends Node2D

func _ready():
	# Set camera limit to the position of the bottom-most tile in the level
	$Player/Camera2D.limit_bottom = 2175
	
	Globals.add_powerup("double_jump")
