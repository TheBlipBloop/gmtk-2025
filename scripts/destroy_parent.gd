extends Node
class_name DestroyParent

@export var delay = 1.0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(delay).timeout
	get_parent().queue_free()
