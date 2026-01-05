extends Node3D
class_name BaseRoom

@export var west_room: BaseRoom = null
@export var east_room: BaseRoom = null
@export var north_room: BaseRoom = null
@export var south_room: BaseRoom = null

@onready var player_position_marker: Marker3D = $PlayerPositionMarker

var adj_rooms_array: Array[BaseRoom] = []
var adj_rooms_directions: Array[String] = ["west_room", "east_room", "north_room", "south_room"]

func _ready() -> void:
	hide()
	await get_tree().create_timer(0.5).timeout
	scan_adj_rooms()

func check_if_adj_have_room(idx: int) -> bool:
	return adj_rooms_array[idx] != null

func scan_adj_rooms() -> void:
	for adj_room_variable: String in adj_rooms_directions:
		adj_rooms_array.append(self.get(adj_room_variable))
	print(to_string() +  " adj rooms scanned | RESULT: " + str(adj_rooms_array))

func get_player_position_in_room() -> Vector3:
	return player_position_marker.global_position
