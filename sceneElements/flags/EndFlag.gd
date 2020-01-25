extends Area2D

func _on_EndFlag_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		Globals.add_powerups_gained_this_level()
		print("yay")
