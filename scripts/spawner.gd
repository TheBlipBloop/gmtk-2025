extends Node3D
class_name Spawner

@export var target : PackedScene
@export var spawn_points: Array = []

func spawn():
	#for point in spawn_points:
		#point = point as Node3D
	var point = self
	
	var new_node = target.instantiate() as Node3D
	get_tree().current_scene.add_child(new_node)
	
	new_node.global_position = point.global_position
	new_node.global_rotation = point.global_rotation
	
