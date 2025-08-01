extends CharacterBody3D

class_name CarMovement

@export var floor_height = 0.16;

@export var loop_component : LoopDetector

@export var acceleration = 5.0
@export var steer_speed = 5.0
@export var min_turn_speed = 0.5
@export var active_drag = 2.0
@export var drag = 5.0

@export var drift_particles: GPUParticles3D

@export var loop_damage_explosion: PackedScene

var m_rotation : float  = 0.0
var m_drift_speed_boost : float = 0

var m_input_accelerate : bool = false

var m_input_boost_right : bool = false
var m_input_boost_left : bool = false

var m_input_mouse_position : Vector3 
var m_last_drift_time_ms: int = -1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _get_input():
	m_input_boost_left = Input.is_action_just_pressed("boost_left")
	m_input_boost_right = Input.is_action_just_pressed("boost_right")
	
	m_input_accelerate = Input.is_action_pressed("thrust")
	m_input_mouse_position = Vector3(CameraMouseHelper.mouse_position.x, 0.0, CameraMouseHelper.mouse_position.y)

	var position_flat : Vector3 = Vector3(global_position.x, 0 , global_position.z)	
	var dir = position_flat.direction_to(m_input_mouse_position)
	m_rotation = atan2(dir.x, dir.z)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# ! HACK !
	Game.player_movement = self
	
	_get_input()
	
	if m_input_accelerate:
		pass
		#loop_component.record_position(global_position)
	else:
		pass
		#loop_component.reset_positions()
		
	if is_drifting():
		m_last_drift_time_ms = Time.get_ticks_msec()
		loop_component.record_position(global_position)
		drift_particles.amount_ratio = 1
	else:
		
		if Time.get_ticks_msec() - m_last_drift_time_ms > 300:
			drift_particles.amount_ratio = 0
			loop_component.reset_positions()
		
	if loop_component.is_loop_complete(global_position):
		on_loop_complete(loop_component.get_loop_radius_and_center())
		loop_component.reset_positions()
		
	if m_input_boost_right or m_input_boost_left:
		if m_input_boost_right:
			dash(basis.x)
		else:
			dash(-basis.x)
		m_input_boost_right = false
		m_input_boost_left = false
	
func on_loop_complete(loopinfo: Vector3):
	var radius: float = loopinfo.x
	var center: Vector3 = Vector3(loopinfo.y, 0, loopinfo.z)
	deal_loop_damage(radius, center)
	
func deal_loop_damage(radius: float, center: Vector3):
	var damage_source: Explosion = loop_damage_explosion.instantiate()
	get_tree().current_scene.add_child(damage_source)
	damage_source.global_position = center;
	damage_source.global_scale(Vector3(radius, radius, radius) * 2.0)
	
	var damage_scalar: float = maxf(1.0, m_drift_speed_boost / 5.0)
	damage_source.apply_damage_scalar(damage_scalar)
	
	 
var dash_velocity: Vector3
func dash(direction):
	return
	# TODO
	velocity += direction.normalized() * 3.0
 
func _physics_process(delta: float) -> void:
	global_position.y = floor_height
	if m_input_accelerate:
		velocity = velocity.move_toward(Vector3.ZERO, active_drag * delta)
		velocity += global_basis.z * acceleration * delta
		rotation.y = lerp_angle(rotation.y, m_rotation, steer_speed * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, drag * delta)
		rotation.y = lerp_angle(rotation.y, m_rotation, steer_speed * delta * 2)
		
	# drift force
	if is_drifting():
		var force = max(acceleration, velocity.length())
		velocity += basis.z * force * delta * m_drift_speed_boost * 0.5;
		m_drift_speed_boost += delta / 5.0 
	else:
		m_drift_speed_boost = move_toward(m_drift_speed_boost, 1.1, delta)
	
	# cornering
	if velocity.dot(basis.z) < 0.7 and m_input_accelerate:
		var force = max(acceleration, velocity.length())
		velocity += basis.z * force * delta * m_drift_speed_boost;
		
	
	move_and_slide();

func is_drifting():
	#return velocity.dot(basis.z) < 0.7 and m_input_accelerate
	return velocity.normalized().dot(basis.z) < 0.45 and m_input_accelerate
