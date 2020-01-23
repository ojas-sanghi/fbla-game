extends Area2D

func _on_RedPortal_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		if Globals.has_powerup("double_jump"):
			get_tree().change_scene_to(load("res://levels/level1/Level1.tscn"))
