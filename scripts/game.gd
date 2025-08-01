extends Node

class_name Game

static var score = 0
static var mult = 1
static var kills = 0

# hellish
static var player_movement : CarMovement
static var player_health : HealthComponent

static func _reset():
	score = 0
	mult = 1
	player_movement = null


static func get_player_position():
	if player_movement == null:
		return Vector3.ZERO
	return player_movement.global_position
	
static func get_player_position_extrapolated(in_seconds: float):		
	if player_movement == null:
		return Vector3.ZERO
	return get_player_position() + player_movement.velocity * in_seconds

static func get_player_health() -> HealthComponent:
	return player_health

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
