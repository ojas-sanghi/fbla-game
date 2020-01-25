extends Node2D

func _ready():
	# Set camera limit to the position of the bottom-most tile in the level
	$Player/Camera2D.limit_bottom = 2175

	Globals.add_powerup("double_jump")

	# Upon the re-loading of the level, the player has already spawned at the start point
	# If this remains true, then if they die in the sublevel and go back to the main level, they'll spawn at the starting
	Globals.player_died = false
