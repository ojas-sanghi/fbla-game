extends Area2D

func _ready() -> void:

	var shape = RectangleShape2D.new()
	shape.extents = get_scale()
	shape.extents.x = shape.extents.x / 4
	$CollisionShape2D.shape = shape

func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	if body:
		if body.name == "Player":
			Globals.in_water = true
	return

func _on_Area2D_body_exited(body: PhysicsBody2D) -> void:
	if body:
		if body.name == "Player":
			Globals.in_water = false