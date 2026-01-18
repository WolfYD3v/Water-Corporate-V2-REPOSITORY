extends Node3D
class_name Map

@export var starting_room: BaseRoom = null

@export_category("SCENES ACTIVATION")
@export var play_intro: bool = true
@export var play_starting_dialog: bool = true

@onready var rooms: Node3D = $Rooms
@onready var player: Player = $Player
@onready var gui: CanvasLayer = $GUI
@onready var intro: Intro = $Intro
@onready var main_menu: MainMenu = $GUI/MainMenu

const PAUSE_MENU = preload("uid://cch6lt3ytnmwx")

var actual_room: BaseRoom = null:
	set(value):
		if actual_room:
			actual_room.active = false
		actual_room = value
		actual_room.active = true
		set_adj_rooms_active_status(true)
		
		player.global_position = actual_room.get_player_position_in_room()
		player.global_position.y = 0.35

func _ready() -> void:
	AlertManager.list_nodes_for_alert_from(self)
	#await AlertManager.scan_finished
	
	actual_room = starting_room
	
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
	
	# INTRO SCENE
	if play_intro:
		intro.process_mode = Node.PROCESS_MODE_ALWAYS
		intro.play()
		await intro.finished
	else:
		intro.queue_free()
		intro = null
	if play_starting_dialog:
		print("DEV_TIP -> Jouer dialogue ici (condition(s) pour ?)")

func try_change_room(next_room_direcion_idx: int) -> void:
	#next_room_direcion_idx = clampi(next_room_direcion_idx, 0, 3)
	set_adj_rooms_active_status(false)
	if actual_room.check_if_adj_have_room(next_room_direcion_idx):
		actual_room = actual_room.adj_rooms_array[next_room_direcion_idx]

func set_adj_rooms_active_status(value: bool = true) -> void:
	for ww: String in actual_room.adj_rooms_directions:
		if actual_room.get(ww):
			var roo: BaseRoom = actual_room.get(ww)
			roo.active = value
