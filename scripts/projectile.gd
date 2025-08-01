extends Node3D
class_name Projectile
@export var raycast: RayCast3D
@export var damage: float = 10
@export var speed: float = 5

# TEMP TEM PTEMP POOLME LATER
func _process(delta: float) -> void:
	update_projectile(delta)

func update_projectile(delta : float ) -> void:
	var hit: bool = travel(delta)
	if hit:
		queue_free()
	
func travel(delta: float) -> bool:
	raycast.target_position = speed * delta * basis.z
	raycast.force_raycast_update()
	
	# no hit keep going
	if raycast.get_collider() == null:
		global_position += speed * delta * basis.z
		return false
	
	# hithox s hit box?
	var collision_obj = raycast.get_collider()
	
	# hellish
	var hitbox = collision_obj.shape_owner_get_owner(collision_obj.shape_find_owner(raycast.get_collider_shape())) as Hitbox
	if hitbox != null:
		hitbox.health_component.damage(damage)
		
	return true

#func wake_from_pool(spawn_position: Vector3, spawn_direction: Vector3):
	#global_position = spawn_position
	#basis.z = spawn_direction
	#visible = true
	#m_active = true
	#
#func return_to_pool():
	#visible = false
	#m_active = false
