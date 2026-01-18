extends Node3D
class_name Speaker

@onready var audio_stream_player: AudioStreamPlayer3D = $AudioStreamPlayer

func play_sound(sound_path: String) -> void:
	audio_stream_player.stream = load(sound_path)
	audio_stream_player.play()

func stop() -> void:
	audio_stream_player.stop()
