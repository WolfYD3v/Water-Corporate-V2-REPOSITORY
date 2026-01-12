extends BaseInteractiveObjects
class_name Computer

@export var auto_boot: bool = true

@onready var sub_viewport: SubViewport = $SubViewport
@onready var speaker_audio_stream_player: AudioStreamPlayer3D = $SpeakerAudioStreamPlayer
@onready var computer_display: ComputerDisplay = $SubViewport/ComputerDisplay

var player_on_computer: bool = false

func _ready() -> void:
	key_to_press_label.hide()
	if auto_boot:
		computer_display.start()

func _input(event: InputEvent) -> void:
	sub_viewport.push_input(event)
	
	if Input.is_key_pressed(key_to_press_to_act) and interaction_timer.is_stopped() and mouse_focused:
		player_on_computer = not(player_on_computer)
		if not player_on_computer:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func act() -> void:
	if player_focused:
		player.rotation.y = rotation.y
	if not auto_boot:
		await get_tree().create_timer(1.5).timeout
		speaker_play_sound("", 0.0, 1.0)
		computer_display.start()

func speaker_play_sound(sound_stream_path: String, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	if speaker_audio_stream_player:
		speaker_audio_stream_player.stream = load(sound_stream_path)
		speaker_audio_stream_player.volume_db = volume_db
		speaker_audio_stream_player.pitch_scale = pitch_scale
		speaker_audio_stream_player.play()
