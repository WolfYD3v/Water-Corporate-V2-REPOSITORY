extends Node3D
class_name Map

@onready var rooms: Node3D = $Rooms
@onready var player: Player = $Player
@onready var gui: CanvasLayer = $GUI
@onready var intro: Intro = $Intro

const PAUSE_MENU = preload("uid://cch6lt3ytnmwx")

var actual_room: BaseRoom = null:
	set(value):
		if actual_room:
			actual_room.active = false
		actual_room = value
		actual_room.active = true
		player.position = actual_room.get_player_position_in_room()
		player.position.y = 0.35

func _ready() -> void:
	actual_room = rooms.get_child(0)
	
	for room: BaseRoom in rooms.get_children():
		room.change_room.connect(try_change_room)
		room.active = false
	
	actual_room.active = true

# FORCE QUIT BABY !!!!!!!!!§§§§!!!!!!!!!!§§§!!!!!!!
func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_Q):
		get_tree().quit()

func _on_main_menu_quitted() -> void:
	gui.add_child(PAUSE_MENU.instantiate())
	# INTRO SCENE
	if true:
		intro.process_mode = Node.PROCESS_MODE_ALWAYS
		intro.play()
	print("DEV_TIP -> Jouer dialogue ici (condition(s) pour ?)")

func try_change_room(next_room_direcion_idx: int) -> void:
	next_room_direcion_idx = clampi(next_room_direcion_idx, 0, 3)
	if actual_room.check_if_adj_have_room(next_room_direcion_idx):
		actual_room = actual_room.adj_rooms_array[next_room_direcion_idx]
