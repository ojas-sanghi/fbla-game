extends Area2D

onready var anim_player := $AnimationPlayer

export var scene_path : String

func _ready() -> void:
	# Hide the black rectange (later used in fade anim) and make it transparent
	anim_player.play("start")
	yield(anim_player, "animation_finished")

	# Play the "idle" portal animation; the 2 frames
	anim_player.play("portal")

func teleport():
	# Play the fade in animation and wait till it finishes
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")

	# Load the path set by us when making the scene
	get_tree().change_scene_to(load(scene_path))

func _on_BluePortal_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		# Set the respawn position to right of the entrance of the blue portal
		# That way, when they finish the sublevel and come back to the main people, then they'll spawn here; it's a checkpoints of sorts
		Globals.blue_respawn_position = Vector2(3900, 420)

		var player = get_tree().get_nodes_in_group("player")
		if player:
			# Stop the movement and animation of the player
			player[0].set_physics_process(false)
			player[0].get_node("AnimationPlayer").stop(false)

		teleport()