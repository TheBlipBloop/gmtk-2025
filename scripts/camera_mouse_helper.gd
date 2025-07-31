extends Camera3D
class_name CameraMouseHelper

static var mouse_position : Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var a = project_position(get_viewport().get_mouse_position(), 1.0)
	mouse_position = Vector2(a.x, a.z)
