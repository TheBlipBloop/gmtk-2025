extends CharacterBody3D

class_name CarMovement

@export var loop_component : LoopDetector

@export var acceleration = 5.0
@export var steer_speed = 5.0
@export var min_turn_speed = 0.5
@export var active_drag = 2.0
@export var drag = 5.0

var m_rotation : float  = 0.0
var m_drift_speed_boost : float = 0
var m_boost_speed_scalar : float = 0

var m_input_accelerate : bool = false
var m_input_rotation : float = 0.0 # sign + => cw; sign - => ccw
var m_input_mouse_position : Vector3 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.player_movement = self

func _get_input():
	m_input_rotation = Input.get_axis("rotate_ccw", "rotate_cw")
	m_input_accelerate = Input.is_action_pressed("thrust")
	m_input_mouse_position = Vector3(CameraMouseHelper.mouse_position.x, 0.0, CameraMouseHelper.mouse_position.y)

	var position_flat : Vector3 = Vector3(global_position.x, 0 , global_position.z)	
	var dir = position_flat.direction_to(m_input_mouse_position)
	m_rotation = atan2(dir.x, dir.z)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_get_input()
	
	if m_input_accelerate:
		loop_component.record_position(global_position)
	else:
		loop_component.reset_positions()
		
	if loop_component.is_loop_complete(global_position):
		loop_component.reset_positions()
		print("looped")
	
 
func _physics_process(delta: float) -> void:
	
	if m_input_accelerate:
		velocity = velocity.move_toward(Vector3.ZERO, active_drag * delta)
		velocity += global_basis.z * acceleration * delta
		rotation.y = lerp_angle(rotation.y, m_rotation, steer_speed * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, drag * delta)
		rotation.y = lerp_angle(rotation.y, m_rotation, steer_speed * delta * 0.2)
		
	# drift force
	if velocity.dot(basis.z) < 0.7 and m_input_accelerate:
		var force = max(acceleration, velocity.length())
		velocity += basis.z * force * delta * m_drift_speed_boost;
		m_drift_speed_boost += delta
	else:
		m_drift_speed_boost = move_toward(m_drift_speed_boost, 1.1, delta)
		
	move_and_slide();
	#if m_input_accelerate:
		#apply_central_force(global_basis.z * acceleration * delta)
		
	#if abs(m_input_rotation) > 0.5 and linear_velocity.length() > min_turn_speed:
		#angular_velocity += Vector3.UP * steer_speed * -m_input_rotation * delta
