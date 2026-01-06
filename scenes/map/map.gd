extends Node3D
class_name Map

@onready var rooms: Node3D = $Rooms
@onready var player: MeshInstance3D = $Player

var actual_room: BaseRoom = null:
	set(value):
		if actual_room:
			actual_room.active = false
		actual_room = value
		actual_room.active = true
		player.position = actual_room.get_player_position_in_room()

func _ready() -> void:
	actual_room = rooms.get_child(0)
	
	for room: BaseRoom in rooms.get_children():
		room.change_room.connect(try_change_room)
		room.active = false
	
	actual_room.active = true

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_LEFT):
			try_change_room(actual_room.west_room_idx)
			player.rotation.y = deg_to_rad(90.0)
		if Input.is_key_pressed(KEY_RIGHT):
			try_change_room(actual_room.east_room_idx)
			player.rotation.y = deg_to_rad(-90.0)
		if Input.is_key_pressed(KEY_UP):
			try_change_room(actual_room.north_room_idx)
			player.rotation.y = deg_to_rad(0.0)
		if Input.is_key_pressed(KEY_DOWN):
			try_change_room(actual_room.south_room_idx)
			player.rotation.y = deg_to_rad(180.0)

func try_change_room(next_room_direcion_idx: int) -> void:
	next_room_direcion_idx = clampi(next_room_direcion_idx, 0, 3)
	if actual_room.check_if_adj_have_room(next_room_direcion_idx):
		actual_room = actual_room.adj_rooms_array[next_room_direcion_idx]
