extends ShapeCast3D
class_name DamageShapeCast3D

func damage_overlaps(damage: float):	
	force_shapecast_update()
	var collisions: int = get_collision_count()
	
	for i in range(collisions):
		var collider : CollisionObject3D = get_collider(i)
		var shape_id = get_collider_shape(i)
	
		var collision_shape = collider.shape_owner_get_owner(collider.shape_find_owner(shape_id))
		var hitbox: Hitbox = collision_shape as Hitbox
		
		if hitbox != null:
			hitbox.health_component.damage(damage)
		
	# TODO
