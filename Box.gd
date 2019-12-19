extends KinematicBody2D

const GRAVITY_VEC = Vector2(0,200)

var linear_vel = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	move_and_slide(linear_vel)

	linear_vel.y = GRAVITY_VEC.y

func _on_Area2DLeft_body_entered(body: PhysicsBody2D) -> void:
	if not body:
		return
	if body.name == "Player":
		linear_vel.x = 200

func _on_Area2DRight_body_entered(body: PhysicsBody2D) -> void:
	if not body:
		return
	if body.name == "Player":
		linear_vel.x = -200

func _on_Area2DRight_body_exited(body: PhysicsBody2D) -> void:
	linear_vel.x = 0

func _on_Area2DLeft_body_exited(body: PhysicsBody2D) -> void:
	linear_vel.x = 0