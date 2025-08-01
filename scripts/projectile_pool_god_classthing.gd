extends Node

class_name ProjectilePool

static var singleton : ProjectilePool

@export var projectile : PackedScene
@export var pool_size = 100

var pool: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	singleton = self
	pool = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#
#
#func populate_pool(count: int):
	#for i in range(count):
		#projectile
