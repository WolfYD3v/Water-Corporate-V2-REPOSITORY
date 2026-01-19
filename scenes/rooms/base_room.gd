extends StaticBody3D
class_name BaseRoom

signal change_room(next_room_direction_idx: int)

@export var west_room: BaseRoom = null
@export var east_room: BaseRoom = null
@export var north_room: BaseRoom = null
@export var south_room: BaseRoom = null

@onready var collision_shape: CollisionShape3D = $CSGBakedCollisionShape3D

@onready var player_position_marker: Marker3D = $PlayerPositionMarker
@onready var change_room_areas: Node3D = $ChangeRoomAreas

var adj_rooms_array: Array[BaseRoom] = []
var adj_rooms_directions: Array[String] = ["west_room", "east_room", "north_room", "south_room"]
var change_rooms_areas_activated: Array[Area3D] = []

var west_room_idx: int = 0
var east_room_idx: int = 1
var north_room_idx: int = 2
var south_room_idx: int = 3
var next_room_direction_idx: int = -1

var active: bool = false:
	set(value):
		active = value
		visible = value
		collision_shape.set_deferred("disabled", not(value))
		set_process(value)
		#if value: set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
		#else: set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
		for change_room_area: Area3D in change_rooms_areas_activated:
			change_room_area.get_child(0).set_deferred("disabled", not(value))
		$Timer.start(0.1)

func _ready() -> void:
	hide()
	await get_tree().create_timer(0.5).timeout
	scan_adj_rooms()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and active:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			_send_change_room_area_trigger()

func check_if_adj_have_room(idx: int) -> bool:
	return adj_rooms_array[idx] != null

func scan_adj_rooms() -> void:
	var idx: int = 0
	for adj_room_variable: String in adj_rooms_directions:
		adj_rooms_array.append(get(adj_room_variable))
		if get(adj_room_variable):
			change_rooms_areas_activated.append(change_room_areas.get_child(idx))
			change_room_areas.get_child(idx).get_child(0).disabled = false
		else:
			change_room_areas.get_child(idx).get_child(0).disabled = true
		idx += 1
	#print(to_string() + " adj rooms scanned | RESULT: " + str(adj_rooms_array))

func get_player_position_in_room() -> Vector3:
	return player_position_marker.global_position

func _send_change_room_area_trigger() -> void:
	if next_room_direction_idx >= 0 and $Timer.is_stopped():
		print(to_string() + str(next_room_direction_idx))
		await get_tree().create_timer(0.1).timeout
		change_room.emit(next_room_direction_idx)



func _on_west_trigger_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("PlayerMouse"):
		next_room_direction_idx = west_room_idx

func _on_west_trigger_area_area_exited(area: Area3D) -> void:
	if area.is_in_group("PlayerMouse"):
		next_room_direction_idx = -1

func _on_east_trigger_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("PlayerMouse"):
		next_room_direction_idx = east_room_idx

func _on_east_trigger_area_area_exited(area: Area3D) -> void:
	if area.is_in_group("PlayerMouse"):
		next_room_direction_idx = -1

func _on_north_trigger_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("PlayerMouse"):
		next_room_direction_idx = north_room_idx

func _on_north_trigger_area_area_exited(area: Area3D) -> void:
	if area.is_in_group("PlayerMouse"):
		next_room_direction_idx = -1

func _on_south_trigger_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("PlayerMouse"):
		next_room_direction_idx = south_room_idx

func _on_south_trigger_area_area_exited(area: Area3D) -> void:
	if area.is_in_group("PlayerMouse"):
		next_room_direction_idx = -1


func _on_west_trigger_area_body_exited(body: Node3D) -> void:
	if body is Player and $Timer.is_stopped():
		change_room.emit(west_room_idx)

func _on_east_trigger_area_body_exited(body: Node3D) -> void:
	if body is Player and $Timer.is_stopped():
		change_room.emit(east_room_idx)

func _on_north_trigger_area_body_exited(body: Node3D) -> void:
	if body is Player and $Timer.is_stopped():
		change_room.emit(north_room_idx)

func _on_south_trigger_area_body_entered(body: Node3D) -> void:
	if body is Player and $Timer.is_stopped():
		change_room.emit(south_room_idx)
