extends Node

class_name Game

static var score = 0
static var mult = 1
static var kills = 0

static var player_movement : CarMovement

static func _reset():
	score = 0
	mult = 1
	player_movement = null

static func player_position():
	if player_movement == null:
		return Vector3.ZERO
	return player_movement.global_position
	
static func player_position_extrapolated(in_seconds: float):		
	if player_movement == null:
		return Vector3.ZERO
	return player_position() + player_movement.velocity * in_seconds

static func notify_demon_death(base_points: float):
	kills += 1
	score += base_points * mult

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_reset() 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if player_movement == null:
		return 
	mult = maxf(1, player_movement.m_drift_speed_boost + player_movement.velocity.length() / 10)
