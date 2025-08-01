extends HealthComponent

class_name PlayerHealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.player_health = self
