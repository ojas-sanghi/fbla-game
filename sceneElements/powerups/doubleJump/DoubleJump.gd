extends Area2D

func _ready():
	# Set some tween properties to be used later as effects when the player picks up the powerup

	# Increase size
	$Tween.interpolate_property($Sprite, 'scale',
		$Sprite.get_scale(), Vector2(0.8, 0.8), 0.6,
		Tween.TRANS_CUBIC, Tween.EASE_OUT)
	# Fade out
	$Tween.interpolate_property($Sprite, 'modulate',
		Color(1, 1, 1, 1), Color(0, 0, 0, 0), 0.6,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)

	# Tween to make the powerup float
	# Not using AnimationPlayer because making the position relative wouldn't be very easy

	# Go up
	$PosTween.interpolate_property(self, 'position',
		position, Vector2(position.x, position.y - 20), 1.5)

	# Start at the up position, then return back to where we were before
	# Delay of 1.5 so that we only go down after we go up
	$PosTween.interpolate_property(self, 'position',
		Vector2(position.x, position.y - 20), position, 1.5, 0, 2, 1.5)

	$PosTween.start()

func _on_DoubleJump_body_entered(body: PhysicsBody2D) -> void:
	if not body or body.name != "Player":
		return
	# Once the player hits the powerup, give them double jump!
	Globals.add_powerup("double_jump")

	# Remove collision shape in order to prevent any more collisions whilst the effect is taking place
	shape_owner_clear_shapes(get_shape_owners()[0])
	# Stop floating
	$PosTween.stop(self)
	# Start tween effect
	$Tween.start()
	# Wait for effect to finish
	yield($Tween, "tween_completed")
	# Get rid of powerup
	queue_free()
