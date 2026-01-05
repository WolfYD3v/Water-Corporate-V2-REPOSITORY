extends Control
class_name MainMenu

func _ready() -> void:
	get_tree().paused = true

func _on_play_button_pressed() -> void:
	hide()
	get_tree().paused = false
