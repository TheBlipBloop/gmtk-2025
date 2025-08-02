# Players that collide with blood pools are given a small amount of health
# ULTRACAR, etc, etc

extends CollisionObject3D
class_name BloodPuddle


@export var initial_size: float =  0.25
@export var initial_size_jitter: float = 0.15

@export var final_size: float = 1.25
@export var final_size_jitter: float = 0.75

@export var spread_speed: float = 7

@export var heal_amount: float = 5.0
@export var puddle_graphics: MeshInstance3D

var m_scale: float = 0;
var m_final_scale: float = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize_initial_scale();
	randomize_final_scale();
	puddle_graphics.scale = (Vector3.ONE * m_scale)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	m_scale = move_toward(m_scale, m_final_scale, delta * spread_speed);
	puddle_graphics.scale = (Vector3.ONE * m_scale)
	
func on_player_overlap(_player: Node3D):
	var health_restored = Game.player_health.heal(heal_amount)
	
	if (health_restored > 0):
		queue_free()

func randomize_initial_scale():
	m_scale = Random.get_rng().randf_range(initial_size - initial_size_jitter, initial_size + initial_size_jitter)

func randomize_final_scale():
	m_final_scale = Random.get_rng().randf_range(final_size - final_size_jitter, final_size + final_size_jitter)
