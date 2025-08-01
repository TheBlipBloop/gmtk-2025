extends Node3D
class_name Spawner

@export var target : PackedScene
@export var spawn_points: Array[Node3D] = []

func spawn():
	if spawn_points.size() == 0:
		spawn_at_point(self)
	
	for point in spawn_points:
		spawn_at_point(point)


func spawn_at_point(point: Node3D) -> Node3D:
	var new_node = target.instantiate() as Node3D
	get_tree().current_scene.add_child(new_node)

	new_node.global_position = point.global_position
	new_node.global_rotation = point.global_rotation

	return new_node
