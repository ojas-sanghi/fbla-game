extends Area2D

signal level_passed

func _on_EndFlag_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		emit_signal("level_passed")
