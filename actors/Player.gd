extends Actor

# var used in double jump code
var _times_jumped := 0
# var to keep track of current animation to be played
var _anim := ""

func _physics_process(delta: float) -> void:
	# If we let go of the jump button mid-jump
	var is_jump_interrupted := Input.is_action_just_released("jump") and _velocity.y < 0.0

	# Do we move left or right
	var direction := get_direction()
	# Overall velocity of where we have to go
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)

	# Move the player, pass where we count the ground to be so that we can check if they're on the ground later
	move_and_slide(_velocity, FLOOR_NORMAL)
	# Play appropriate animation
	animate_player(_velocity)

# Returns how fast we should go in either direction, and if we're jumping
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
	# Make new var
	var new_vel := linear_velocity

	# Get x by multiplying the speed (script var) times how much the key is being held down
	new_vel.x = speed.x * direction.x

	# Add gravity to the vertical movement
	new_vel.y += gravity * get_physics_process_delta_time()
	# Cap the downward force
	if new_vel.y > gravity_limit:
		new_vel.y = gravity_limit

	# If we're going up, then multiply the speed times how much the key is being held down
	if direction.y == -1.0:
		new_vel.y = speed.y * direction.y

	# If player let go of jump key mid-jump, then set vertical velocity to 0 (gravity will be applied to it next frame)
	if is_jump_interrupted:
		new_vel.y = 0

	return new_vel

# Returns whether or not the player can jump
func can_jump() -> bool:
	# If they've pressed the jump button
	if Input.is_action_just_pressed("jump"):
		# Let them jump if they're on the floor, regardless
		if is_on_floor():
			# Increse the jump counter
			_times_jumped = 1 # reset to 0, then increment 1
			return true
		# If they have the powerup and they've only jumped once, let them jump again
		if Globals.has_powerup("double_jump") and _times_jumped == 1:
			_times_jumped += 1
			return true
	# If they didn't press jump, if they try to double jump without the powerup, or if they try to jump for a third time mid-air
	return false

func animate_player(linear_vel: Vector2) -> void:

	# Default new anim
	var new_anim := "idle"

	if is_on_floor():
		# If they hit the ground after falling, play the hit_ground animation
		# But it won't do this if they land in water; the swim animation will play then
		if _anim == "fall" and not Globals.in_water:
			$AnimationPlayer.play("hit_ground")
			yield($AnimationPlayer, "animation_finished")

		# Flip the sprite horizontally if they're moving left
		if linear_vel.x < 0:
			$Sprite.set_flip_h(true)
			new_anim = "walk"

		# Undo any existing flip if they're moving to the right
		if linear_vel.x > 0:
			$Sprite.set_flip_h(false)
			new_anim = "walk"
	else:
		# If they're going up, set the jumping animation
		# Otherwise, set the fall animation
		if linear_vel.y < 0:
			new_anim = "jump"
		else:
			new_anim = "fall"

	# Play the swim animation if they're in the water
	if Globals.in_water:
		new_anim = "swim"

	# Play the new animation if it's different
	if new_anim != _anim:
		_anim = new_anim
		$AnimationPlayer.play(_anim)

func kill_player():
	# Set a global variable, and remove any powerups they've gained this level
	Globals.player_died = true
	Globals.remove_powerups_gained_this_level()

	# Stop mvovement
	set_physics_process(false)

	# Play death anim
	$AnimationPlayer.play("death")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.stop(true)

	# Wait for 0.25s
	yield(get_tree().create_timer(0.25), "timeout")

	# Reload scene
	get_tree().reload_current_scene()
