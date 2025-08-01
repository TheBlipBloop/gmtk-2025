extends Node

class_name Game

static var score = 0
static var mult = 1

static var player_movement : CarMovement

static func _reset():
	score = 0
	mult = 1
	player_movement = null

static func player_position():
	return player_movement.global_position
	
static func player_position_extrapolated(in_seconds: float):
	return player_position() + player_movement.velocity * in_seconds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mult = maxf(1, player_movement.m_drift_speed_boost)
