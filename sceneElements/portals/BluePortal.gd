extends Area2D

func _on_Portal_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to(preload("res://levels/level1/SubLevel1.tscn"))
