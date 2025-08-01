extends Node
class_name EnemyMovement

@export var movement_speed : float = 17
@export var TEMP_projectile_spawmer : Spawner
var m_body : RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	m_body = get_parent() as RigidBody3D

func _physics_process(delta: float) -> void:
	move_to_player()

func _process(delta: float) -> void:
	if randf() < 0.02:
		TEMP_projectile_spawmer.look_at(Game.get_player_position_extrapolated(0.5), Vector3.UP, true)
		TEMP_projectile_spawmer.spawn()

func move_to_player():
	var dir = m_body.global_position.direction_to(Game.get_player_position())
	dir.y = 0
	dir = dir.normalized()
	m_body.linear_velocity = dir
