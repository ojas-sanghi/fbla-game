extends Area2D

func _ready() -> void:
	# Make a new rectangle shape
	var shape = RectangleShape2D.new()
	# Get current scale then divide by 4 to get the appropriate size needed
	shape.extents = get_scale()
	shape.extents.x = shape.extents.x / 4
	# Set collision shape to the one we just made
	$CollisionShape2D.shape = shape

func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	if body:
		if body.name == "Player":
			# Set the global in_water var to true when the player enters the water area
			Globals.in_water = true
	return

func _on_Area2D_body_exited(body: PhysicsBody2D) -> void:
	if body:
		if body.name == "Player":
			# Set the global in_water var to false when the player leaves the water area
			Globals.in_water = false
