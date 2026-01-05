extends Node3D
class_name Map

@onready var rooms: Node3D = $Rooms
@onready var player: MeshInstance3D = $Player

var actual_room: BaseRoom = null:
	set(value):
		if actual_room:
			actual_room.hide()
		actual_room = value
		actual_room.show()
		player.position = actual_room.get_player_position_in_room()

func _ready() -> void:
	actual_room = rooms.get_child(0)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_LEFT) and actual_room.check_if_adj_have_room(0):
			actual_room = actual_room.west_room
			player.rotation.y = deg_to_rad(90.0)
		if Input.is_key_pressed(KEY_RIGHT) and actual_room.check_if_adj_have_room(1):
			actual_room = actual_room.east_room
			player.rotation.y = deg_to_rad(-90.0)
		if Input.is_key_pressed(KEY_UP) and actual_room.check_if_adj_have_room(2):
			actual_room = actual_room.north_room
			player.rotation.y = deg_to_rad(0.0)
		if Input.is_key_pressed(KEY_DOWN) and actual_room.check_if_adj_have_room(3):
			actual_room = actual_room.south_room
			player.rotation.y = deg_to_rad(180.0)
