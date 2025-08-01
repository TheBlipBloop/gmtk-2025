# Spawner that spawns once a certain number of kills have been made & time elapsed
extends Spawner
class_name WaveSpawner

@export var kills_to_activate: int = 0
@export var delay: float = 2.5

var m_triggered: bool = false

func _process(delta: float) -> void:
	if Game.kills >= kills_to_activate and not m_triggered:
		m_triggered = true 
		_try_spawn()

func _try_spawn() -> void:
	await get_tree().create_timer(delay).timeout
	spawn()
