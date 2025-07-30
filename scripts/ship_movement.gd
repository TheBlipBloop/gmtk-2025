extends RigidBody3D

class_name Movement

# Base movement speeds
@export var base_rotation_speed : float = 5.0;
@export var base_move_speed : float = 0.1;

# Boosted movement speeds
@export var boost_rotation_speed : float = 2.0;
@export var boost_move_speed : float = 1.5;

var m_boost_speed_scalar : float = 0;
var m_input_rotation : float = 0.0 # sign + => cw; sign - => ccw
var m_input_boosting : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event):
	pass
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	m_input_rotation = 0
	if Input.is_action_pressed("rotate_cw"):
		m_input_rotation += 1
	if Input.is_action_pressed("rotate_ccw"):
		m_input_rotation -= 1
		
	m_input_boosting = Input.is_action_pressed("thrust")
	print(m_input_rotation)
	
func _physics_process(delta: float) -> void:
	angular_velocity += Vector3.UP * m_input_rotation * -get_rotation_speed() * delta;
	linear_velocity += basis.z * get_move_speed() * delta;
		
func get_rotation_speed() -> float:
	if (m_input_boosting):
		return boost_rotation_speed
	return base_rotation_speed;
		
func get_move_speed() -> float:
	if (m_input_boosting):
		return boost_move_speed
	return base_move_speed
