extends KinematicBody2D

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



