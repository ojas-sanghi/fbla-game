extends Actor

var _times_jumped := 0
var _anim := ""

signal player_died

func _ready() -> void:
	self.connect("player_died", self, "on_player_died");

	var flags = get_tree().get_nodes_in_group("flags")
	if flags:
		flags[0].connect("level_passed", self, "on_level_passed")

func _physics_process(delta: float) -> void:
	# If we let go of the jump button mid-jump
	var is_jump_interrupted := Input.is_action_just_released("jump") and _velocity.y < 0.0

	var direction = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)

	move_and_slide(_velocity, FLOOR_NORMAL)
	animate_player(_velocity)

	# Checks to see if we hit a triangle (death tile)
	for i in get_slide_count():
		var collision := get_slide_collision(i)
		if collision.collider is TileMap:
			check_tilemap_collision(collision)

func get_direction() -> Vector2:
	# Returns how fast we should go in either direction
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

	# Get x by multiplying the speed (script vars) times how much the key is being held down
	new_vel.x = speed.x * direction.x

	# Get the new y buy multiplying the gravity times the delta
	new_vel.y += gravity * get_physics_process_delta_time()
	# Cap the downward force
	if new_vel.y > gravity_limit:
		new_vel.y = gravity_limit

	# If we're going up, then multiply the speed times how much the key is being held down
	if direction.y == -1.0:
		new_vel.y = speed.y * direction.y

	# If player let go of jump key mid-jump, then go down again
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

func check_tilemap_collision(collision):
	var tile_pos = collision.collider.world_to_map(position)
	tile_pos -= collision.normal # colliding tile
	var tile = collision.collider.get_cellv(tile_pos) # get cell index
	if tile == 12: # we've hit a triangle, hardcoded tile index
		emit_signal("player_died")

func on_player_died():
	set_physics_process(false)

	$AnimationPlayer.play("death")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.stop(true)
	yield(get_tree().create_timer(0.25), "timeout")

	get_tree().reload_current_scene()

func on_level_passed():
	print("yay")