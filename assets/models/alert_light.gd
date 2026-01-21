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
	if active:
		spot_light.show()
		await get_tree().create_timer(0.6).timeout
		spot_light.hide()
		await get_tree().create_timer(0.6).timeout
		_start()

func _stop() -> void:
	spot_light.hide()
