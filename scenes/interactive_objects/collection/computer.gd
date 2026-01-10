extends BaseInteractiveObjects
class_name Computer

@onready var sub_viewport: SubViewport = $SubViewport

func _input(event: InputEvent) -> void:
	sub_viewport.push_input(event)
