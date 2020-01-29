extends KinematicBody2D

# Gravity being applied to box
const GRAVITY_VEC = Vector2(0, 500)

# Initial velocity is 0
var _velocity: = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Move by the velocity
	move_and_slide(_velocity)

	# Set vertical velocity to the gravity constant
	_velocity.y = GRAVITY_VEC.y

func _on_Area2DLeft_body_entered(body: PhysicsBody2D) -> void:
	# Solves weird problem if there is a ghost collision
	if not body:
		return
	# Set x velocity if the player is hitting the box
	if body.name == "Player":
		_velocity.x = 250

func _on_Area2DRight_body_entered(body: PhysicsBody2D) -> void:
	if not body:
		return
	# Set x velocity if the player is hitting the box
	if body.name == "Player":
		_velocity.x = -250

func _on_Area2DRight_body_exited(body: PhysicsBody2D) -> void:
	# Stop moving if the player left
	_velocity.x = 0

func _on_Area2DLeft_body_exited(body: PhysicsBody2D) -> void:
	# Stop moving if the player left
	_velocity.x = 0

