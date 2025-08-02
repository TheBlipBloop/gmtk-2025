## Detects 2D Looping Motions
### First version just checks for ~intersection with path, in the future can do convexity checks, etc

extends Node
class_name LoopDetector

@export var min_distance : float = 0.5;
@export var threshold : float = 1.5;

var positions : Array = []; ## ! Arrays are actually lists -- its like python but dumber.

func record_position(new_position: Vector3):
	var position_flat: Vector2 = Vector2(new_position.x, new_position.z)
	
	if positions.size() == 0:
		positions.append(position_flat)
		return
	
	var last_position : Vector2 = positions[positions.size() - 1]
	if last_position.distance_to(position_flat) > min_distance:
		positions.append(position_flat)
	
func reset_positions():
	if positions.size() == 0:
		return
	positions.clear()
	
func is_loop_complete(current_position: Vector3) -> bool:
	var position_flat: Vector2 = Vector2(current_position.x, current_position.z)
	
	for i in range(int(positions.size() / 3)):
		if positions[i].distance_to(position_flat) < threshold:
			return true
	return false
	
func get_loop_center() -> Vector2:
	var total : Vector2 = Vector2.ZERO
	for pos in positions:
		total += pos 

	return total / positions.size()
	
func get_loop_radius() -> float:
	var max_distance_from_center = 0
	var center = get_loop_center()
	var dist: float = 0
	for pos in positions:
		dist = center.distance_squared_to(pos)
		if (dist > max_distance_from_center):
			max_distance_from_center = dist 
	
	return sqrt(max_distance_from_center)	
	
# Returns vector in format : (radius, center.x, center.y) because no fucking tuples :/
# GDScript really is good if you like things that are bad
func get_loop_radius_and_center() -> Vector3:
	var max_distance_from_center = 0
	var center = get_loop_center()
	var dist: float = 0
	for pos in positions:
		dist = center.distance_squared_to(pos)
		if (dist > max_distance_from_center):
			max_distance_from_center = dist 
	
	return Vector3(sqrt(max_distance_from_center), center.x, center.y)
