extends BaseInteractiveObjects
class_name Computer

@onready var sub_viewport: SubViewport = $SubViewport

var player_on_computer: bool = false

func _ready() -> void:
	key_to_press_label.hide()

func _input(event: InputEvent) -> void:
	sub_viewport.push_input(event)
	
	if Input.is_key_pressed(key_to_press_to_act) and interaction_timer.is_stopped() and mouse_focused:
		#player_on_computer = false
		player_on_computer = not(player_on_computer)
		if not player_on_computer:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func act() -> void:
	#player_on_computer = true
	if player_focused:
		player.rotation.y = rotation.y
