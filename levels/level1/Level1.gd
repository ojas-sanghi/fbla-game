extends Node2D

func _ready():
	# Set camera limit to the position of the last tile in the level
	$Player/Camera2D.limit_right = 6272
	
	if Globals.player_died:
		Globals.respawn_position = Vector2(374, 677)
		Globals.player_died = false

	var player = get_tree().get_nodes_in_group("player")
	if player:
		if Globals.respawn_position != Vector2():
			player[0].position = Globals.respawn_position
