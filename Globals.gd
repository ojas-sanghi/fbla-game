extends Node

var respawn_position := Vector2()
var in_water := false
var player_died := false

var powerups := []
var powerups_gained_this_level := []

func _ready() -> void:
#	powerups.append("double_jump")

#	var player = get_tree().get_nodes_in_group("player")
#	if player:
#		player[0].connect("player_died", self, "on_player_died")
	return

func add_powerup(powerup: String) -> void:
	powerups.append(powerup)
	powerups_gained_this_level.append(powerup)

func has_powerup(powerup: String) -> bool:
	return powerups.has(powerup)

func remove_powerup(powerup: String) -> void:
	var index = powerups.find(powerup)
	if index != -1:
		powerups.remove(index)

func remove_powerups_gained_this_level():
	for powerup in powerups_gained_this_level:
		remove_powerup(powerup)

func add_powerups_gained_this_level():
	for i in range(0, powerups_gained_this_level.size()):
		add_powerup(powerups_gained_this_level[i])
		powerups_gained_this_level.remove(i)