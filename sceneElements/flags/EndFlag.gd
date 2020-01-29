extends Area2D

func _on_EndFlag_body_entered(body: PhysicsBody2D) -> void:
	# Once the player reaches the green flag
	if body.name == "Player":
		# Permanently add the powerups they got this level
		Globals.add_powerups_gained_this_level()
		print(Globals.powerups)
		# For now just print yay, later on save progress and move to next level.
		print("yay")
