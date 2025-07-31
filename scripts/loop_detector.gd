## Detects 2D Looping Motions
### First version just checks for ~intersection with path, in the future can do convexity checks, etc

extends Node
class_name LoopDetector

@export var min_distance : float = 0.5;
@export var threshold : float = 0.5;

var positions : Array = []; ## ! Arrays are actually lists -- its like python but dumber.

func record_position(new_position: Vector2):
	if positions.size() == 0:
		positions.append(new_position)
		return
	
	var last_position : Vector2 = positions[positions.size() - 1]
	if last_position.distance_to(new_position) > min_distance:
		positions.append(new_position)
	
func reset_positions():
	positions.clear()
	
func is_loop_complete(current_position: Vector2) -> bool:
	for i in range(positions.size() - 3):
		if positions[i].distance_to(current_position) < threshold:
			return true
	return false
	
func get_loop_center() -> Vector2:
	var total : Vector2 = Vector2.ZERO
	for pos in positions:
		total += pos 

	return total / positions.size()
