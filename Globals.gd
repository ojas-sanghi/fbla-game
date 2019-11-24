extends Node

var in_water: bool = false

var powerups: Array = []

func _ready() -> void:
	powerups.append("double_jump")

func add_powerup(powerup: String) -> void:
	powerups.append(powerup)

func has_powerup(powerup: String) -> bool:
	return powerups.has(powerup)