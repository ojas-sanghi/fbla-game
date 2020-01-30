extends Area2D

# Export two options for the sprite of the spikes
export(String, "Low", "High") var spikes_type = "High"

func _ready() -> void:
	# Load the set sprite version
	var spikes_string = "res://assets/included/Other/spikes" + spikes_type + ".png"
	$Sprite.texture = load(spikes_string)

	# Change collisionshape based on which sprite version is chosen
	if spikes_string == "Low":
		$CollisionShape2D.position = Vector2(0, -3)
	else:
		$CollisionShape2D.position = Vector2(0, -5)

func _on_Spikes_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		# Kill player upon impact
		body.kill_player()
