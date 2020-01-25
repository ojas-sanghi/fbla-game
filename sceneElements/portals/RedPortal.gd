extends Area2D

onready var anim_player := $AnimationPlayer

export var scene_path : String

func _ready() -> void:
	anim_player.play("start")
	yield(anim_player, "animation_finished")
	anim_player.play("portal")

func teleport():
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(load(scene_path))

func _on_RedPortal_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		if Globals.has_powerup("double_jump"):
			set_physics_process(false)

			var player = get_tree().get_nodes_in_group("player")
			if player:
				player[0].set_physics_process(false)
				player[0].get_node("AnimationPlayer").stop(false)

			teleport()