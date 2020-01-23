extends Area2D

onready var anim_player := $AnimationPlayer

func _ready() -> void:
	anim_player.play("start")
	yield(anim_player, "animation_finished")
	anim_player.play("portal")

func teleport():
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(preload("res://levels/level1/SubLevel1.tscn"))

func _on_BluePortal_body_entered(body: PhysicsBody2D) -> void:
	if body.name == "Player":
		Globals.respawn_position = body.position
		Globals.respawn_position.x += 50 # to prevent them from immediately going back into the portal upon coming back
		teleport()