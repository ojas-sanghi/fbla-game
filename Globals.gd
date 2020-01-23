extends Node

var respawn_position := Vector2()
var in_water := false

var powerups := []

func _ready() -> void:
	powerups.append("double_jump")
	return

func add_powerup(powerup: String) -> void:
	powerups.append(powerup)

func has_powerup(powerup: String) -> bool:
	return powerups.has(powerup)