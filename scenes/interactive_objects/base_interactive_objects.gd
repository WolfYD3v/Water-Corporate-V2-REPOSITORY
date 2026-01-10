extends Node3D
class_name BaseInteractiveObjects

@onready var player_obj_position: Marker3D = $PlayerObjPosition
@onready var interaction_timer: Timer = $InteractionTimer

@export var key_to_press_to_act: Key = KEY_E
@export var interaction_timer_waiting_time: float = 0.5

var captured_player_position: Vector3 = Vector3.ZERO:
	set(value):
		captured_player_position = value
		print(value)

var player_focused: bool = false
var mouse_focused: bool = false:
	set(value):
		mouse_focused = value
var player: Player = null

# Override if a custom ready is needed
func _ready() -> void:
	pass

# Empty function to override to give a custom behavoir to inheritance scenes 
func act() -> void:
	# CUSTOM CODE HERE
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_key_pressed(key_to_press_to_act) and interaction_timer.is_stopped() and player:
			interaction_timer.start(interaction_timer_waiting_time)
			player_focused = not(player_focused)
			player.can_move = not(player_focused)
			player.can_rotate = not(player_focused)
			
			if player_focused and mouse_focused:
				captured_player_position = player.global_position
				print("Player in")
				player.global_position = player_obj_position.global_position
				act()
			else:
				print("Player out")
				player.global_position = captured_player_position


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
