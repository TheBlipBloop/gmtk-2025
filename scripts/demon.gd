extends RigidBody3D
class_name Demon

# Points for killing this type of demon
@export var points: float = 100
@export var corpse: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_death():
	Game.notify_demon_death(points)
	spawn_corpse()
	queue_free()
	
func spawn_corpse():
	var new_corpse = corpse.instantiate() as RigidBody3D
	get_tree().current_scene.add_child(new_corpse)
	
	new_corpse.global_position = global_position
	new_corpse.global_rotation =  global_rotation
	new_corpse.linear_velocity = Random.get_random_unit_vector() * 4 + Vector3.UP * 2
