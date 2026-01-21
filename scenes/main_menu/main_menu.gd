extends Control
class_name MainMenu

signal quitted

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var buttons: HBoxContainer = $Buttons
@onready var ambiance_audio_stream_player: AudioStreamPlayer = $AmbianceAudioStreamPlayer
@onready var button_clicked_sfx_audio_stream_player: AudioStreamPlayer = $ButtonClickedSFXAudioStreamPlayer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	
	hide()
	animation_player.play("MainMenuAnims/OpenMenu")
	show()
	
	ambiance_audio_stream_player.volume_db = -80.0
	ambiance_audio_stream_player.play()

func _on_play_button_pressed() -> void:
	button_clicked_sfx_audio_stream_player.play()
	
	ambiance_audio_stream_player.volume_db = 0.0
	ambiance_audio_stream_player.play()
	animation_player.play("MainMenuAnims/CloseMenu")
	await animation_player.animation_finished
	ambiance_audio_stream_player.stop()
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	await get_tree().create_timer(3.5).timeout
	hide()
	get_tree().paused = false
	quitted.emit()

func _on_quit_button_pressed() -> void:
	button_clicked_sfx_audio_stream_player.play()
	get_tree().quit()

func set_buttons_disable(value: bool) -> void:
	for button: Button in buttons.get_children():
		button.disabled = value


func _on_credits_button_pressed() -> void:
	button_clicked_sfx_audio_stream_player.play()
	print("SHOW CREDITS")
	get_tree().quit()
