extends Node

# Vectors to hold respawn points for Level1 and SubLevel1
var blue_respawn_position := Vector2()
var red_respawn_position := Vector2()

var in_water := false
var player_died := false

# List to keep track of all powerups, and those gained this level
var powerups := []
var powerups_gained_this_level := []

func add_powerup(powerup: String) -> void:
	# Add powerup to more "permanent" list and to list of powerups gained this level
	powerups.append(powerup)
	powerups_gained_this_level.append(powerup)

# Return whether or not the player has the passed powerup
func has_powerup(powerup: String) -> bool:
	return powerups.has(powerup)

# Remove passed powerup
func remove_powerup(powerup: String) -> void:
	var index = powerups.find(powerup)
	if index != -1:
		powerups.remove(index)

# Removes all powerups gained this level
func remove_powerups_gained_this_level():
	# Remove powerups which we got only this level
	for powerup in powerups_gained_this_level:
		remove_powerup(powerup)
	# Reset list
	powerups_gained_this_level = []

# Adds powerups gained this level
func add_powerups_gained_this_level():
	for i in range(0, powerups_gained_this_level.size()):
		# Remove it from the "temporary list"
		powerups_gained_this_level.remove(i)
		# It's already in the powerups list (the more "temporary" list); we added it in the add_powerup() method itself, so we don't need to mess with it now.
