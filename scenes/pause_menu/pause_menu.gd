extends Control
class_name PauseMenu

func _ready() -> void:
	hide()

func _change_pause_state() -> void:
	visible = not(visible)
	get_tree().paused = not(get_tree().paused)
	if visible: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_ESCAPE):
			_change_pause_state()

func _on_continue_button_pressed() -> void:
	_change_pause_state()
