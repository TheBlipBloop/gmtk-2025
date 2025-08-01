extends RayCast3D
class_name BleedPoint

@export var blood_prefab: PackedScene
@export var blood_height_offset: float = 0.25

@export var bleed_max: int = 5
@export var bleed_interval: float = 0.2			# Min time between spawning bleed effects
@export var min_move_distance: float = 0.35		# Min distance this object must move before spawning another bleed efffect
@export var blood_cast_distance: float = 0.5	# How far to check for bleedable surface?

@export var positional_jitter = 0.4

var m_last_bleed_tick_ms: int = 0
var m_last_bleed_position: Vector3 = Vector3.ZERO
var m_bleed_count: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if m_bleed_count >= bleed_max:
		queue_free()
		return
		 
	try_bleed()

func try_bleed() -> bool:
	if Time.get_ticks_msec() - m_last_bleed_tick_ms < bleed_interval * 1000:
		return false 
	if global_position.distance_to(m_last_bleed_position) < min_move_distance:
		return false

	var jitter = positional_jitter * Random.get_random_unit_vector() # not correct but close enough ig 
	target_position = global_basis.inverse() * (Vector3(jitter.x, -blood_cast_distance, jitter.z))
	force_raycast_update()
	
	if not is_colliding():
		return false
	
	var hit_point: Vector3 = get_collision_point()
	var blood_node: BloodPuddle = blood_prefab.instantiate()
	get_tree().current_scene.add_child(blood_node)
	blood_node.global_position = hit_point + Vector3.UP * blood_height_offset
	
	m_last_bleed_tick_ms = Time.get_ticks_msec()
	m_last_bleed_position = global_position
	m_bleed_count += 1
	
	return true
