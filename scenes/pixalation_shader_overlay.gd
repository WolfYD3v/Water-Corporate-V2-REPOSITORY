extends ColorRect
class_name PixalationShaderOverlay

@export var animated: bool = false:
	set(value):
		animated = value
		if value: _animate()
		else: _stop()
var pixelation_shader_values_array: Array[float] = [0.006, 0.0075, 0.0055, 0.0035, 0.005]
var shader_material: ShaderMaterial = null
var animation_waiting_time: float = 0.35

func _ready() -> void:
	shader_material = material
	print(shader_material)
	_set_pixelation_param(pixelation_shader_values_array[-1])
	
	if animated: _animate()

func _animate() -> void:
	_set_pixelation_param(pixelation_shader_values_array[-1])
	for pixelation_shader_param: float in pixelation_shader_values_array:
		if animated:
			_set_pixelation_param(pixelation_shader_param)
			await get_tree().create_timer(animation_waiting_time).timeout
	if animated: _animate()

func _set_pixelation_param(value_to_set: float, print_value_to_set: bool = false) -> void:
	if not shader_material: return
	
	if print_value_to_set: print(value_to_set)
	shader_material.set_shader_parameter("pixelation", value_to_set)

func _stop() -> void:
	_set_pixelation_param(pixelation_shader_values_array[-1])
