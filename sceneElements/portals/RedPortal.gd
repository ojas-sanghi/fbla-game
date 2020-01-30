extends Area2D

onready var anim_player := $AnimationPlayer

# String for the scene to load when entering portal
export var scene_path : String

# Bool in order to toggle whether or not we should check if the player must have double jump
export var ensure_double_jump : bool = true
# Bool in order to toggle whether or not the player should teleport whatsoever.
export var enable_teleport : bool = true

# Note: the fact that we are "export"-ing these variables lets us change them for each instance of them!

func _ready() -> void:
	# Hide the black rectange (later used in fade anim) and make it transparent
	anim_player.play("start")
	yield(anim_player, "animation_finished")

	# Play the "idle" portal animation; the 2 frames
	anim_player.play("portal")

func teleport():
	# Don't do anything if we don't want the portal to teleport at all
	if not enable_teleport:
		return

	# Set the respawn point in the sublevel to be next to where they entered
	Globals.red_respawn_position = Vector2(950, 992)

	var player = get_tree().get_nodes_in_group("player")
	if player:
		# Stop player movement and animation
		player[0].set_physics_process(false)
		player[0].get_node("AnimationPlayer").stop(false)

	# Play the blackout animation, wait till it's done
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")

	# Load the scene to change to
	# See BluePortal.gd for a comment on why we load a String to the scene instead of asking for a PackedScene object through the inspector
	get_tree().change_scene_to(load(scene_path))

func _on_RedPortal_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		# Check if they have double jump if we're set to
		if ensure_double_jump:
			if Globals.has_powerup("double_jump"):
				teleport()
			else:
				return
		else:
			# Teleport if we don't have to check
			teleport()
