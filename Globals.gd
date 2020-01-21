extends Node

var sprite_colors := ["Blue", "Red", "Green", "Grey"]
var current_sprite_color := "Red"

var powerups := []

func _ready() -> void:
	powerups.append("double_jump")
	return

func add_powerup(powerup: String) -> void:
	powerups.append(powerup)

func has_powerup(powerup: String) -> bool:
	return powerups.has(powerup)