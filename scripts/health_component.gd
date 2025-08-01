extends Node

class_name HealthComponent

@export var max_health = 100
@export var health = 100

signal on_damaged
signal on_death

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func damage(amount: float):
	print(health)
	_change_health(-amount)

func heal(amount: float):
	_change_health(amount)

func is_dead()->bool:
	return health < 0.1

func _change_health(delta: float):
	var prev_health = health
	health = clamp(health + delta, 0.0, max_health)
	
	
	var real_delta : float = health - prev_health
	if (real_delta < 0):
		on_damaged.emit(abs(real_delta))
	if health == 0 and abs(delta) > 0.001:
		on_death.emit()
