extends Node3D

@export var set_visible: bool = true

func _ready() -> void:
	visible = set_visible
