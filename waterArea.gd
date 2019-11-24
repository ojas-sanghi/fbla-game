extends Area2D

#var in_water: bool = false

func _ready() -> void:

	var shape = RectangleShape2D.new()
	shape.extents = get_scale()
	print(get_scale())
	print(shape.extents)
	$CollisionShape2D.shape = shape

func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	if body:
		if body.name != "Player":
			return
	else:
		return
	Globals.in_water = true
#	while(Globals.in_water):
#		pass


func _on_Area2D_body_exited(body: PhysicsBody2D) -> void:
	Globals.in_water = false
