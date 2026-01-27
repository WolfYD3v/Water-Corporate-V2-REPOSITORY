@tool
extends MeshInstance3D
class_name PropangandaFrame

enum FRAME_CONTENT {
	GODOT = 1,
	WINDOWS_95 = 2,
	WATER_1 = 3
}
@export var frame_content: FRAME_CONTENT = FRAME_CONTENT.GODOT:
	set(value):
		frame_content = value
		_set_texture()

var frames_file_path: Dictionary[int, String] = {
	1: "res://assets/textures/propaganda_posters/propanganda_posters_godot.png",
	2: "res://assets/textures/propaganda_posters/propanganda_posters_windows_95.png",
	3: "res://assets/textures/propaganda_posters/propanganda_posters_water_1t.png"
}

func _ready() -> void:
	_set_texture()

func _set_texture() -> void:
	var material: StandardMaterial3D = get_surface_override_material(0).duplicate()
	material.albedo_texture = load(
		frames_file_path.get(frame_content)
	)
	set_surface_override_material(0, material)
