extends Area2D

onready var anim_player := $AnimationPlayer

# String for the scene to load when entering portal
export var scene_path : String
# Bool in order to toggle whether or not the player should teleport whatsoever.
export var enable_teleport : bool = true

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

	# Set the respawn position to right of the entrance of the blue portal
	# That way, when they finish the sublevel and come back to the main people, then they'll spawn here; it's a checkpoints of sorts
	Globals.blue_respawn_position = Vector2(3900, 420)

	var player = get_tree().get_nodes_in_group("player")
	if player:
		# Stop the movement and animation of the player
		player[0].set_physics_process(false)
		player[0].get_node("AnimationPlayer").stop(false)

	# Play the fade in animation and wait till it finishes
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")

	# Load the path set by us when making the scene (viewable on the right side of the screen)
	# Interesting to note: we cannot load PackedScene objects, because those are essentially the same as pre-loading a string. That is fine, but if we do that for both the Blue and Red portals, it won't work. That's because the Level1 has the Blue portal, which loads (and has a dependency on) SubLevel1, which has the Red portal, which in turn loads (and has a dependency) on Level1. You cannot have cylic dependencies, so we have to specify a string which is loaded in dynamically upon playtime.
	get_tree().change_scene_to(load(scene_path))

func _on_BluePortal_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		teleport()
