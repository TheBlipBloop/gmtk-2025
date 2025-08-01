extends RigidBody3D
class_name Demon

# Points for killing this type of demon
@export var points: float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_death():
	Game.notify_demon_death(points)
	queue_free()
