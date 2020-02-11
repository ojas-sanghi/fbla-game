extends Area2D

func _on_EndFlag_body_entered(body: PhysicsBody2D) -> void:
	# Once the player reaches the green flag
	if body.name == "Player":
		# Permanently add the powerups they got this level
		Globals.add_powerups_gained_this_level()
		# Switch to the "You Won!" screen
		$AnimationPlayer.play("fade_in")
		yield($AnimationPlayer, "animation_finished")
		get_tree().change_scene("res://GUI/screens/LevelPassedScreen.tscn")
