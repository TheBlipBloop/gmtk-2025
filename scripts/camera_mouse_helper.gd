extends Camera3D
class_name CameraMouseHelper

static var mouse_position : Vector2
var viewport_cache: Viewport

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if viewport_cache == null:
		viewport_cache = get_viewport()
		
	var mouse_position_projected = project_position(viewport_cache.get_mouse_position(), 1.0)
	mouse_position = Vector2(mouse_position_projected.x, mouse_position_projected.z)
