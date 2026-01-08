extends Node3D
class_name BaseInteractiveObjects

@export var key_to_press_to_act: Key = KEY_E

var mouse_focused: bool = false:
	set(value):
		mouse_focused = value
		print(value)

# Override if a custom ready is needed
func _ready() -> void:
	pass

# Empty function to override to give a custom behavoir to inheritance scenes 
func act() -> void:
	# CUSTOM CODE HERE
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_key_pressed(key_to_press_to_act) and mouse_focused:
			act()


func _on_player_detection_area_area_entered(area: Area3D) -> void:
	if area.is_in_group("PlayerMouse"):
		mouse_focused = true

func _on_player_detection_area_area_exited(area: Area3D) -> void:
	if area.is_in_group("PlayerMouse"):
		mouse_focused = false

func _on_player_detection_area_body_entered(body: Node3D) -> void:
	if body is Player:
		mouse_focused = true

func _on_player_detection_area_body_exited(body: Node3D) -> void:
	if body is Player:
		mouse_focused = false
