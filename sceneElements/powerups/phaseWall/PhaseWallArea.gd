extends Area2D

func _ready() -> void:
	# Make a new rectangle shape
	var shape = RectangleShape2D.new()
	shape.extents.x = 1
	shape.extents.y = 1

	# How much to increase the shape by so that the Area2D shape is larger
	var offset = 0.005

	# Increase size a bit
	shape.extents.x += offset
	shape.extents.y += offset

	# Set collision shape to the one we just made
	$CollisionShape2D.set("shape", shape)

	# Duplicate collision shape
	var shape2 = RectangleShape2D.new()

	shape2.extents.x = 1
	shape2.extents.y = 1

	$StaticBody2D/CollisionShape2D.set("shape", shape2)

func _on_PhaseWallArea_body_entered(body: PhysicsBody2D) -> void:
	if body:
		if body.name == "Player":
			if Globals.has_powerup("phase_wall"):
				$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
