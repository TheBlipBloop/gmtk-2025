extends Area3D

@export var strength: float = 10;
var bodies : Array = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta_time: float) -> void:
	for body : RigidBody3D in bodies:
		var delta : Vector3 = body.global_position - global_position
		body.apply_force(-delta * strength)


func _on_body_entered(body: Node3D) -> void:
	bodies.append(body);

func _on_body_exited(body: Node3D) -> void:
	bodies.remove_at(bodies.find(body))
