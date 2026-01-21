extends Node3D
class_name Speaker

@onready var alarm_sound_audio_stream_player: AudioStreamPlayer3D = $AlarmSoundAudioStreamPlayer
@onready var alar_voice_over_audio_stream_player: AudioStreamPlayer3D = $AlarVoiceOverAudioStreamPlayer

func play_sound() -> void:
	alarm_sound_audio_stream_player.play()
	alar_voice_over_audio_stream_player.play()

func stop() -> void:
	alarm_sound_audio_stream_player.stop()
	alar_voice_over_audio_stream_player.stop()
