class_name Random

static var rng = null

static func get_rng() -> RandomNumberGenerator:
	if rng == null:
		rng = RandomNumberGenerator.new()
		rng.randomize()
	return rng

static func get_random_unit_vector() -> Vector3:
	return Vector3(get_rng().randf_range(-1.0, 1.0), get_rng().randf_range(-1.0, 1.0), 
					get_rng().randf_range(-1.0, 1.0)).normalized()
