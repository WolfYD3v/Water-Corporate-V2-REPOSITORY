extends Node3D
class_name WaterSource

@onready var water_mesh: MeshInstance3D = $WaterMesh
@onready var csg_baked_mesh_instance_3d: MeshInstance3D = $CSGBakedMeshInstance3D

var filled_water_mesh_y_position: float = 0.8
var empty_water_mesh_y_position: float = -1.9
var water_level_value: float = 1.0

func _ready() -> void:
	reset_water()

func reset_water() -> void:
	water_level_value = 1.0
	water_mesh.position.y = filled_water_mesh_y_position
	csg_baked_mesh_instance_3d.rotation.y = deg_to_rad(
		randf_range(-360.0, 360.0)
	)

# Aide de Gemini
# LIEN DE LA CONVERSATION - https://gemini.google.com/share/e695fe10f073
func lower_water_level() -> void:
	water_level_value = clampf(
		water_level_value - 0.005,
		0.0,
		1.0
	)
	water_mesh.position.y = lerpf(empty_water_mesh_y_position, filled_water_mesh_y_position, water_level_value)
	
	# TEMP
	if water_level_value <= 0.0:
		reset_water()
