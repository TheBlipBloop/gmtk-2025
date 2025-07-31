extends RigidBody3D

class_name Movement

@export var camera : Camera3D;

@export var base_slow_down_speed : float = 0.2;

# Base movement speeds
@export var base_rotation_speed : float = 5.0;
@export var base_move_speed : float = 0.1;

# Boosted movement speeds
@export var boost_rotation_speed : float = 2.5;
@export var boost_move_speed : float = 1.75;

@export var loop_boost_speed : float = 3.5;

@export var looper_component : LoopDetector;
@export var marker_node : PackedScene;
@export var thrust_particles : GPUParticles3D


var m_drift_speed_boost : float = 0
var m_boost_speed_scalar : float = 0
var m_input_rotation : float = 0.0 # sign + => cw; sign - => ccw
var m_input_boosting : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	m_input_rotation = 0
	
	#var positionflat = Vector2(global_position.x, global_position.z)
	#m_input_rotation = CameraMouseHelper.mouse_position.angle_to(positionflat)
	#m_input_rotation = clampf(m_input_rotation, -1, 1)
	if Input.is_action_pressed("rotate_cw"):
		m_input_rotation += 1
	if Input.is_action_pressed("rotate_ccw"):
		m_input_rotation -= 1
	m_input_boosting = Input.is_action_pressed("thrust")
	
	if m_input_boosting:
		thrust_particles.amount_ratio = 1;
		looper_component.record_position(Vector2(global_position.x, global_position.z))
	else:
		thrust_particles.amount_ratio = 0;
		
		looper_component.reset_positions()
		
	if looper_component.is_loop_complete(Vector2(global_position.x, global_position.z)):
		var center : Vector2 = looper_component.get_loop_center()
		var a = marker_node.instantiate() as Node3D
		get_tree().root.add_child(a)
		
		a.global_position = Vector3(center.x, 0.0, center.y)
		
		looper_component.reset_positions()
		print("loop complete");
		_boost()

func _boost():
	linear_velocity += basis.z * loop_boost_speed
	angular_velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	angular_velocity += Vector3.UP * m_input_rotation * -_get_rotation_speed() * delta;
	linear_velocity += basis.z * _get_move_speed() * delta;
	
	# drift force
	if linear_velocity.dot(basis.z) < 0.0 and m_input_boosting:
		var force = max(_get_move_speed(), linear_velocity.length())
		linear_velocity += basis.z * force * delta * m_drift_speed_boost;
		m_drift_speed_boost += delta / 4
	else:
		m_drift_speed_boost = 1.1
	
	if not m_input_boosting:
		linear_velocity = linear_velocity.move_toward(Vector3.ZERO, delta * base_slow_down_speed);
		
func _get_rotation_speed() -> float:
	if (m_input_boosting):
		return boost_rotation_speed
	return base_rotation_speed;
		
func _get_move_speed() -> float:
	if (m_input_boosting):
		return boost_move_speed
	return base_move_speed
