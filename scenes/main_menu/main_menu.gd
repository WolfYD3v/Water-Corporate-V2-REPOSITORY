extends Control
class_name MainMenu

signal quitted

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var buttons: HBoxContainer = $Buttons

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	
	hide()
	animation_player.play("MainMenuAnims/OpenMenu")
	show()

func _on_play_button_pressed() -> void:
	animation_player.play("MainMenuAnims/CloseMenu")
	await animation_player.animation_finished
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()
	get_tree().paused = false
	quitted.emit()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func set_buttons_disable(value: bool) -> void:
	for button: Button in buttons.get_children():
		button.disabled = value
