extends Area2D

func _on_BluePortal_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		Globals.respawn_position = body.position
		Globals.respawn_position.x += 50 # to prevent them from immediately going back into the portal upon coming back
		get_tree().change_scene_to(preload("res://levels/level1/SubLevel1.tscn"))
