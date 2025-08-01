extends Node3D
class_name Explosion
@export var damage_initial: float = 25
@export var damage_shape_cast: DamageShapeCast3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## HACK basically the ready function is run before the new scales are applied so we wait one frame
	await get_tree().process_frame
	damage_shape_cast.damage_overlaps(damage_initial)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func apply_damage_scalar(scalar: float):
	damage_initial *= scalar
