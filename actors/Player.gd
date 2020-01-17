extends Actor

var _times_jumped := 0
var _anim := ""

func _physics_process(delta: float) -> void:
	var is_jump_interrupted := Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	move_and_slide(_velocity, FLOOR_NORMAL)
	animate_player(_velocity)

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if can_jump() else 1.0
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var new_vel := linear_velocity

	new_vel.x = speed.x * direction.x

	new_vel.y += gravity * get_physics_process_delta_time()
	if new_vel.y > speed.y:
		new_vel.y = speed.y

	if direction.y == -1.0:
		new_vel.y = speed.y * direction.y

	if is_jump_interrupted:
		new_vel.y = 0

	return new_vel

func can_jump():
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			_times_jumped = 1 # reset to 0, then increment 1
			return true
		if Globals.has_powerup("double_jump") and _times_jumped == 1: # if they have the powerup and they've only jumped once, let them jump again
			_times_jumped += 1
			return true
	return false

func animate_player(
	linear_vel: Vector2
	):

	var new_anim := "idle"

	if is_on_floor():
		# If they hit the ground after falling, play the hit_ground animation
		# But it won't do this if they land in water; the swim animation will play then
		if _anim == "fall" and not Globals.in_water:
			$AnimationPlayer.play("hit_ground")
			yield($AnimationPlayer, "animation_finished")

		if linear_vel.x < 0:
			$Sprite.set_flip_h(true)
			new_anim = "walk"

		if linear_vel.x > 0:
			$Sprite.set_flip_h(false)
			new_anim = "walk"
	else:
		# Immediately face the side player is moving
		if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			$Sprite.set_flip_h(true)
		if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
			$Sprite.set_flip_h(false)

		# If they're going up, set the jumping animation
		# Otherwise, set the fall animation
		if linear_vel.y < 0:
			new_anim = "jump"
		else:
			new_anim = "fall"

	# swim animation if they're in the water
	if Globals.in_water:
		new_anim = "swim"

	if new_anim != _anim:
		_anim = new_anim
		$AnimationPlayer.play(_anim)

"""
func check_tilemap_collision(collision):
	var tile_pos = collision.collider.world_to_map(position)
	tile_pos -= collision.normal # colliding tile
	var tile = collision.collider.get_cellv(tile_pos)
	if tile == 12: # we've hit a triangle
		emit_signal("player_died")
"""