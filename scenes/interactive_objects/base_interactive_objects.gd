extends Node3D
class_name BaseInteractiveObjects

@export var change_player_position: bool = true

@onready var player_obj_position: Marker3D = $PlayerObjPosition
@onready var interaction_timer: Timer = $InteractionTimer
@onready var key_to_press_label: MeshInstance3D = $KeyToPressLabel

@export var key_to_press_to_act: Key = KEY_E
@export var interaction_timer_waiting_time: float = 0.1

var captured_player_position: Vector3 = Vector3.ZERO

var player_focused: bool = false
var mouse_focused: bool = false:
	set(value):
		mouse_focused = value
		key_to_press_label.visible = value
var player: Player = null

# Override if a custom ready is needed
func _ready() -> void:
	key_to_press_label.hide()

# Empty function to override to give a custom behavoir to inheritance scenes 
func act() -> void:
	# CUSTOM CODE HERE
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_key_pressed(key_to_press_to_act) and interaction_timer.is_stopped() and player:
			interaction_timer.start(interaction_timer_waiting_time)
			player_focused = not(player_focused)
			player.can_move = not(player.can_move)
			player.can_rotate = not(player.can_rotate)
			
			print(player.can_move)
			print(player.can_rotate)
			
			if player_focused and mouse_focused:
				key_to_press_label.visible = false
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
				act()
			else:
				key_to_press_label.visible = true
				if change_player_position:
					print("Player out")
					player.change_position(captured_player_position)


func _on_player_detection_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("PlayerMouse"):
		mouse_focused = true
		player = area.get_parent()

func _on_player_detection_area_area_exited(area: Area3D) -> void:
	if area.is_in_group("PlayerMouse"):
		mouse_focused = false
		player = null

func _on_player_detection_area_body_entered(body: Node3D) -> void:
	if body is Player:
		mouse_focused = true
		player = body

func _on_player_detection_area_body_exited(body: Node3D) -> void:
	if body is Player:
		mouse_focused = false
		player = null
