extends Node3D
class_name AlertLight

@onready var spot_light: SpotLight3D = $SpotLight

var active: bool = false:
	set(value):
		active = value
		if value: _start()
		else: _stop()

func _ready() -> void:
	spot_light.hide()

func _start() -> void:
	for loop: int in range(2):
		spot_light.visible = not(spot_light.visible)
		await get_tree().create_timer(randf_range(0.5, 0.65)).timeout
	if active: _start()

func _stop() -> void:
	spot_light.hide()
