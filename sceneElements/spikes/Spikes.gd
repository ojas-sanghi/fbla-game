extends Area2D

export(String, "Low", "High") var spikes_type = "High"

signal player_died

func _ready() -> void:
	var spikes_string = "res://assets/included/PNG/Other/spikes" + spikes_type + ".png"
	$Sprite.texture = load(spikes_string)

	if spikes_string == "Low":
		$CollisionShape2D.position = Vector2(0, -3)
	else:
		$CollisionShape2D.position = Vector2(0, -5)

func _on_Spikes_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		emit_signal("player_died")
