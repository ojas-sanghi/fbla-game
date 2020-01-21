extends Actor

var _times_jumped := 0
var _anim := ""
var _in_water := false

var _sprite : Node

signal player_died

func _ready() -> void:
	trigger_sprite_change()
#	var _sprite_color := Globals.current_sprite_color
#	_sprite = get_node("Sprite" + _sprite_color)

# Set new sprite color visible, enable hitbox.
# Hide and disable sprites and hitboxes for all other colors.
func trigger_sprite_change():
	var _sprite_color := Globals.current_sprite_color
	_sprite = get_node("Sprite" + _sprite_color)
	_sprite.visible = true
	get_node("Collision" + _sprite_color).visible = true
	get_node("Collision" + _sprite_color).disabled = false

	for color in Globals.sprite_colors:
		print(color)
		if color != _sprite_color:
			print(color)
			get_node("Sprite" + _sprite_color).visible = false
			get_node("Collision" + _sprite_color).visible = false
			get_node("Collision" + _sprite_color).disabled = true

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
			check_if_died(collision)

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

func animate_player(linear_vel: Vector2) -> void:

	var new_anim := "idle"

	if is_on_floor():
		# If they hit the ground after falling, play the hit_ground animation
		# But it won't do this if they land in water; the swim animation will play then
		if _anim == "fall" and not _in_water:
			new_anim = "hit_ground"

		if linear_vel.x < 0:
			_sprite.set_flip_h(true)
			new_anim = "walk"

		if linear_vel.x > 0:
			_sprite.set_flip_h(false)
			new_anim = "walk"
	else:
		# If they're going up, set the jumping animation
		# Otherwise, set the fall animation
		if linear_vel.y < 0:
			new_anim = "jump"
		else:
			new_anim = "fall"

	# swim animation if they're in the water
	if _in_water:
		new_anim = "swim"

	if new_anim != _anim:

		var current_anim = $AnimationPlayer.get_animation("walk")
		var anim_path_strings := make_anim_string(new_anim)
		for i in range(0, anim_path_strings.size()):
			current_anim.track_get_key_value(0, i).set_path(anim_path_strings[i])
			print(current_anim.track_get_key_value(0, 1).get_path())

		_anim = new_anim
		$AnimationPlayer.play(_anim)

func check_if_died(collision):
	var tile_pos = collision.collider.world_to_map(position)
	tile_pos -= collision.normal # colliding tile
	var tile = collision.collider.get_cellv(tile_pos) # get cell index
	if tile == 12: # we've hit a triangle, hardcoded tile index
		emit_signal("player_died")

func make_anim_string(new_anim : String) -> Array:
	var new_path := ""

	new_path = "res://assets/included/PNG/Players/Player " + Globals.current_sprite_color + "/player" + Globals.current_sprite_color + "_"

	if new_anim == "hit_ground":
		return [new_path + "hit.png"]

	new_path += new_anim

	if new_anim == "swim":
		return [new_path + "1.png", new_path + "2.png"]
	elif new_anim == "jump":
		return [new_path + "1.png", new_path + "2.png", new_path + "3.png", new_path + "2.png"]
	elif new_anim == "walk":
		return [new_path + "1.png", new_path + "2.png", new_path + "3.png", new_path + "4.png"]
	else:
		return [new_path + ".png"]