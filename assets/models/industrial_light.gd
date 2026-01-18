extends Node3D
class_name IndustrialLight

@export var can_flicker: bool = true:
	set(value):
		can_flicker = value
		if value:
			#turn_on()
			flicker()
		else:
			turn_off()
@export var min_random_flickering_time: float = 10.0
@export var max_random_flickering_time: float = 25.0

@onready var spot_light: SpotLight3D = $SpotLight
@onready var sfx_audio_stream_player: AudioStreamPlayer3D = $SFXAudioStreamPlayer
@onready var light_mesh_instance_2: MeshInstance3D = $LightMeshInstance2

func _ready() -> void:
	turn_on()
	can_flicker = true

func turn_on() -> void:
	spot_light.show()
	light_mesh_instance_2.hide()
	sfx_audio_stream_player.pitch_scale = randf_range(0.9, 1.1)
	sfx_audio_stream_player.play()

func turn_off() -> void:
	spot_light.hide()
	light_mesh_instance_2.show()
	sfx_audio_stream_player.pitch_scale = randf_range(0.9, 1.1)
	sfx_audio_stream_player.play()

func flicker() -> void:
	await get_tree().create_timer(
		randf_range(min_random_flickering_time, max_random_flickering_time)
	).timeout
	for loop: int in range(randi_range(1, 3)):
		turn_off()
		await get_tree().create_timer(0.1).timeout
		turn_on()
		await get_tree().create_timer(0.2).timeout
	await get_tree().create_timer(0.3).timeout
	
	if can_flicker: flicker()
	else: turn_off()
