extends Actor

var _times_jumped := 0

func _physics_process(delta: float) -> void:
	var is_jump_interrupted := Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	move_and_slide(_velocity, FLOOR_NORMAL)

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

"""
extends KinematicBody2D

signal player_died

const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const WALK_SPEED = 400 # pixels/sec
const JUMP_SPEED = 550
const SIDING_CHANGE_SPEED = 10

var linear_vel = Vector2()
var anim = ""

# counter to manage jumping and double-jumping
var times_jumped = 0

# cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = $Sprite

func get_input() -> int:
	# return desired left-right movement
	var target_speed = 0
	if Input.is_action_pressed('ui_right'):
		target_speed += 1
	if Input.is_action_pressed('ui_left'):
		target_speed -= 1

	return target_speed

func _physics_process(delta) -> void:

	# Apply gravity
	linear_vel += delta * GRAVITY_VEC
	# Move and slide
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	# Detect if we are on floor - only works if called *after* move_and_slide
	var on_floor = is_on_floor()

	var target_speed = get_input()

	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

	# Jumping
	if Input.is_action_just_pressed("ui_up"):
		# only let them double jump if they have that powerup
		if Globals.has_powerup("double_jump"):
			# ensure they can only double jump
			if times_jumped < 1:
				linear_vel.y = -JUMP_SPEED
				times_jumped += 1
		else: # if they don't, only let them jump once
			if times_jumped == 0:
				linear_vel.y = -JUMP_SPEED
				times_jumped += 1
	if on_floor: # reset the counter when they touch the floor
		times_jumped = 0


	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider is TileMap:
			check_tilemap_collision(collision)

	#### ANIMATION ####

	var new_anim = "idle"

	if on_floor:
		# If they hit the ground after the falling, play the hit_ground animation
		# But it won't do this if they land in water; the swim animation will play then
		if anim == "fall" and not Globals.in_water:
			$AnimationPlayer.play("hit_ground")
			yield($AnimationPlayer, "animation_finished")

		if linear_vel.x < -SIDING_CHANGE_SPEED:
			sprite.set_flip_h(true)
			new_anim = "walk"

		if linear_vel.x > SIDING_CHANGE_SPEED:
			sprite.set_flip_h(false)
			new_anim = "walk"
	else:
		# We want the character to immediately change facing side when the player
		# tries to change direction, during air control.
		# This allows for example the player to shoot quickly left then right.
		if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			sprite.set_flip_h(true)
		if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
			sprite.set_flip_h(false)

		# If they're going up, set the jumping animation
		# Otherwise, set the fall animation
		if linear_vel.y < 0:
			new_anim = "jump"
		else:
			new_anim = "fall"

	# swim animation if they're in the water
	if Globals.in_water:
		new_anim = "swim"

	if new_anim != anim:
		anim = new_anim
		$AnimationPlayer.play(anim)

func check_tilemap_collision(collision):
	var tile_pos = collision.collider.world_to_map(position)
	tile_pos -= collision.normal # colliding tile
	var tile = collision.collider.get_cellv(tile_pos)
	if tile == 12: # we've hit a triangle
		emit_signal("player_died")
"""