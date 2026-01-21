extends BaseInteractiveObjects
class_name Computer

@export var auto_boot: bool = true

@onready var sub_viewport: SubViewport = $SubViewport
@onready var speaker_audio_stream_player: AudioStreamPlayer3D = $SpeakerAudioStreamPlayer
@onready var computer_display: ComputerDisplay = $SubViewport/ComputerDisplay
@onready var screen_display_mesh_instance: MeshInstance3D = $ScreenDisplayMeshInstance
@onready var gui: CanvasLayer = $GUI

var player_on_computer: bool = false
var computer_booted: bool = false

func _ready() -> void:
	key_to_press_label.hide()
	gui.hide()
	if auto_boot:
		computer_display.start()

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(key_to_press_to_act) and interaction_timer.is_stopped():
		interaction_timer.start(interaction_timer_waiting_time)
		player_on_computer = not(player_on_computer)
		gui.visible = not(gui.visible)
		if not player_on_computer and mouse_focused:
			computer_display.reparent(sub_viewport, false)
			computer_display = get_node("SubViewport/ComputerDisplay")
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			computer_display.reparent(gui, true)
			computer_display = get_node("GUI/ComputerDisplay")
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func move_computer_display(current_location: Node, new_location: Node) -> void:
	print(current_location.get_children())
	var temp_computer_display = current_location.get_child(0)
	print(temp_computer_display)
	current_location.remove_child(temp_computer_display)
	new_location.add_child(temp_computer_display)
	#await get_tree().create_timer(1.0).timeout
	computer_display = new_location.get_child(0)
	print(new_location.get_children())

func act() -> void:
	if player_focused:
		player.rotation.y = rotation.y
	if not auto_boot and not computer_booted:
		computer_booted = true
		await get_tree().create_timer(1.5).timeout
		speaker_play_sound("res://assets/sfxs/CMPTMisc_Demarrage d un ibook g4 (ID 0157)_LS.mp3", -25.0, 1.0) # SON TEMP
		computer_display.start()

func speaker_play_sound(sound_stream_path: String, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	if speaker_audio_stream_player:
		speaker_audio_stream_player.stream = load(sound_stream_path)
		speaker_audio_stream_player.volume_db = volume_db
		speaker_audio_stream_player.pitch_scale = pitch_scale
		speaker_audio_stream_player.play()
