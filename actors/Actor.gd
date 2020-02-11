extends KinematicBody2D
class_name Actor

# Where we define the floor to be
const FLOOR_NORMAL: = Vector2.UP

# Speed
export var speed := Vector2(300, 1000)
# Force of gravity
export var gravity: = 2500
# Limit of how many pixels/s the player can be pulled down at
export var gravity_limit := 800

# Initial velocity is 0
var _velocity: = Vector2.ZERO
