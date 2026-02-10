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
	WorkingDaysManager.shift_ended.connect(turn_off)
	key_to_press_label.hide()
	gui.hide()
	if auto_boot:
		computer_display.start()

func _process(_delta: float) -> void:
	if not mouse_focused: return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if GlobalVariables.player:
			player = GlobalVariables.player
		if not WorkingDaysManager._shift_can_start:
			if not WorkingDaysManager.is_shift_started():
				says_smth()
			return
		print(player)
		if interaction_timer.is_stopped() and player and mouse_focused:
			interaction_timer.start(interaction_timer_waiting_time)
			player_focused = not(player_focused)
			player.can_move = not(player.can_move)
			player.can_rotate = not(player.can_rotate)
			
			print(player_focused)
			print(mouse_focused)
			
			if player_focused and mouse_focused:
				key_to_press_label.visible = false
				act()
				await get_tree().create_timer(0.1).timeout
				if change_player_position:
					captured_player_position = player.position
					print("Player in")
					await player.change_position(Vector3(
						player_obj_position.global_position.x,
						0.35,
						player_obj_position.global_position.z
					), true, true)
					player.can_move = not(player.can_move)
					player.can_rotate = not(player.can_rotate)
				thingy()

func thingy() -> void:
	if mouse_focused:
		interaction_timer.start(interaction_timer_waiting_time)
		player_on_computer = not(player_on_computer)
		gui.visible = true
		if not player_on_computer and mouse_focused:
			pass
		else:
			computer_display.reparent(gui, true)
			computer_display = get_node("GUI/ComputerDisplay")
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func act() -> void:
	print("act")
	
	if player_focused:
		player.rotation.y = rotation.y
	if not auto_boot and not computer_booted:
		computer_booted = true
		await get_tree().create_timer(1.5).timeout
		speaker_play_sound("res://assets/sfxs/computer_button_pressed_sfx.wav", 20.0, 1.5) # SON TEMP
		computer_display.start()

func speaker_play_sound(sound_stream_path: String, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	if speaker_audio_stream_player:
		speaker_audio_stream_player.stream = load(sound_stream_path)
		speaker_audio_stream_player.volume_db = volume_db
		speaker_audio_stream_player.pitch_scale = pitch_scale
		speaker_audio_stream_player.play()

func turn_off() -> void:
	computer_booted = false
	computer_display.turn_off_display()
	_on_computer_display_quit_computer()


func _on_computer_display_quit_computer() -> void:
	#if player_focused and mouse_focused: return
	
	key_to_press_label.visible = true
	player_on_computer = false
	gui.visible = false
	if change_player_position:
		print("Player out")
		player.change_position(captured_player_position, true, true)
	
	computer_display.reparent(sub_viewport, false)
	computer_display = get_node("SubViewport/ComputerDisplay")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func says_smth() -> void:
	player.can_move = false
	player.can_rotate = false
	GlobalVariables.dialog_scene.stop()
	GlobalVariables.dialog_scene.show()
	if GlobalVariables.dialog_scene:
		await GlobalVariables.dialog_scene.write_text(
			"You",
			"I should sleep instead."
		)
	await get_tree().create_timer(2.0).timeout
	GlobalVariables.dialog_scene.hide()
	player.can_move = true
	player.can_rotate = true
