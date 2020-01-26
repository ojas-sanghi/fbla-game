extends Node2D

func _ready():
	# Set camera limit to the position of the bottom-most tile in the level
	$Player/Camera2D.limit_bottom = 2175

	if Globals.player_died:
		Globals.red_respawn_position = Vector2(202, 1953)
		Globals.player_died = false

	var player = get_tree().get_nodes_in_group("player")
	if player:
		if Globals.red_respawn_position != Vector2():
			player[0].position = Globals.red_respawn_position

	if Globals.has_powerup("double_jump"):
		$QuizPortal.queue_free()
