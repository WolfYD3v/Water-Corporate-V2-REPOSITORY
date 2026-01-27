extends Node3D
class_name Map

@export var starting_room: BaseRoom = null

@export_category("SCENES ACTIVATION")
@export var play_context: bool = true
@export var play_intro: bool = true
@export var play_starting_dialog: bool = true

@onready var rooms: Node3D = $Rooms
@onready var player: Player = $Player
@onready var gui: CanvasLayer = $GUI
@onready var intro: Intro = $Intro
@onready var main_menu: MainMenu = $GUI/MainMenu
@onready var dialog_scene: DialogScene = $GUI/DialogScene
@onready var context_introduction: ContextIntroduction = $GUI/ContextIntroduction

@onready var tutorial_node: Node3D = $"Rooms/ReceptionRoom(2,6)/Tutorial"

const PAUSE_MENU = preload("uid://cch6lt3ytnmwx")

var actual_room: BaseRoom = null:
	set(value):
		if actual_room:
			actual_room.active = false
		actual_room = value
		actual_room.active = true
		
		if not player.free_roam_enable:
			player.change_position(Vector3(
				actual_room.get_player_position_in_room().x,
				0.35,
				actual_room.get_player_position_in_room().z
			), allow_player_walking_sequence)
		
		set_adj_rooms_active_status(true)
var allow_player_walking_sequence: bool = true

func _ready() -> void:
	tutorial_node.hide()
	AlertManager.list_nodes_for_alert_from(self)
	#await AlertManager.scan_finished
	
	allow_player_walking_sequence = false
	actual_room = starting_room
	allow_player_walking_sequence = true
	
	for room: BaseRoom in rooms.get_children():
		room.change_room.connect(try_change_room)
		room.active = false
	
	actual_room.active = true
	set_adj_rooms_active_status(true)

# FORCE QUIT BABY !!!!!!!!!§§§§!!!!!!!!!!§§§!!!!!!!
func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_Q):
		get_tree().quit()

func _on_main_menu_quitted() -> void:
	gui.add_child(PAUSE_MENU.instantiate())
	
	main_menu.hide()
	tutorial_node.show()
	
	# CONTEXT
	if play_context:
		context_introduction.play()
		await context_introduction.finished
	else: context_introduction.queue_free()
	
	# INTRO SCENE
	if play_intro:
		intro.process_mode = Node.PROCESS_MODE_ALWAYS
		intro.play()
		await intro.finished
	else:
		intro.queue_free()
		intro = null
	if play_starting_dialog:
		tutorial()

func try_change_room(next_room_direcion_idx: int) -> void:
	if tutorial_node:
		tutorial_node.queue_free()
	print(to_string() + str(next_room_direcion_idx))
	#next_room_direcion_idx = clampi(next_room_direcion_idx, 0, 3)
	set_adj_rooms_active_status(false)
	if actual_room.check_if_adj_have_room(next_room_direcion_idx):
		actual_room = actual_room.adj_rooms_array[next_room_direcion_idx]

func set_adj_rooms_active_status(value: bool = true) -> void:
	for _adj_room_direction: String in actual_room.adj_rooms_directions:
		if actual_room.get(_adj_room_direction):
			var _adj_room: BaseRoom = actual_room.get(_adj_room_direction)
			_adj_room.visible = value
			_adj_room.set_process(value)

func tutorial() -> void:
	player.can_move = false
	player.can_rotate = false
	
	dialog_scene.play_dialog("tutorial")
	await dialog_scene.ended
	
	player.can_move = true
	player.can_rotate = true
