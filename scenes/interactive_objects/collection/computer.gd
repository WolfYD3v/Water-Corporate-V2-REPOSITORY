extends BaseInteractiveObjects
class_name Computer

@onready var sub_viewport: SubViewport = $SubViewport

var player_on_computer: bool = false

func _input(event: InputEvent) -> void:
	sub_viewport.push_input(event)
	
	if Input.is_key_pressed(key_to_press_to_act) and player_on_computer:
		#player_on_computer = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func act() -> void:
	player_on_computer = true
	if player_focused:
		player.rotation.y = rotation.y
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
