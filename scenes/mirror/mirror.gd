extends Node3D
class_name Mirror

@onready var sub_viewport: SubViewport = $SubViewport
@onready var mirror_mesh_instance: MeshInstance3D = $MirrorMeshInstance


var mirror_material: StandardMaterial3D = null

func _ready() -> void:
	mirror_material = mirror_mesh_instance.get_surface_override_material(0)

func _process(_delta: float) -> void:
	if visible:
		if not mirror_material:
			mirror_material = mirror_mesh_instance.get_surface_override_material(0)
		var sub_viewport_texture: Image = sub_viewport.get_texture().get_image()
		var mirror_material_albed_texture: ImageTexture = ImageTexture.create_from_image(sub_viewport_texture)
		#print(sub_viewport_texture)
		mirror_material.albedo_texture = mirror_material_albed_texture
