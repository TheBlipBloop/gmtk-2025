extends Node3D
class_name Projectile
@export var raycast: RayCast3D
@export var damage: float = 10
@export var knockback: float = 2.0
@export var speed: float = 5
@export var lifetime: float = 2.5

var m_destroy_time: float = 0

func _ready():
	m_destroy_time = Time.get_ticks_msec() / 1000.0 + lifetime

# TEMP TEM PTEMP POOLME LATER
func _process(delta: float) -> void:
	update_projectile(delta)

func update_projectile(delta : float ) -> void:
	var hit: bool = travel(delta)
	if hit or _lifetime_expired():
		queue_free()
	
func travel(delta: float) -> bool:
	raycast.target_position = speed * delta * Vector3.BACK
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
		
		## Awful check if we hit the player to do Knockback
		if hitbox.health_component == Game.player_health:
			Game.player_movement.apply_knockback(knockback * basis.z)
	return true

func _lifetime_expired() -> bool:
	return Time.get_ticks_msec() / 1000.0 >= m_destroy_time
#func wake_from_pool(spawn_position: Vector3, spawn_direction: Vector3):
	#global_position = spawn_position
	#basis.z = spawn_direction
	#visible = true
	#m_active = true
	#
#func return_to_pool():
	#visible = false
	#m_active = false
