extends CSGBox3D
class_name Wall

@export var have_pipes: bool = false

@onready var pipes: CSGCombiner3D = $Pipes

func _ready() -> void:
	if not have_pipes: pipes.queue_free()
