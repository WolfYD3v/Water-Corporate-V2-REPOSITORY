extends Control
class_name DialogScene

signal ended

@onready var label: Label = $Label

var _tween
var _running: bool = false

var dialogs_files_folder_path: String = "res://scenes/dialog_scene/dialogs/"

func _ready() -> void:
	hide()
	label.text = ""

func _load_dialog_file(file_name: String) -> Dictionary:
	var dialog_file = FileAccess.open(
		dialogs_files_folder_path + file_name + ".json",
		FileAccess.READ
	)
	var dialog_data: Dictionary = JSON.parse_string(dialog_file.get_as_text())
	dialog_file.close()
	if dialog_data == null:
		return {}
	print(dialog_data)
	return dialog_data

func is_running() -> bool:
	return _running

func write_text(_who: String, _text: String) -> void:
	label.text = _who + "\n" + "\n" + _text
	label.visible_ratio = 0.0
	
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.tween_property(label, "visible_ratio", 1.0, 1.0)
	await _tween.finished

func play_dialog(_dialog_name: String) -> void:
	if is_running(): return
	
	_running = true
	show()
	
	var dialog_data: Dictionary = _load_dialog_file(_dialog_name)
	
	for current_dialog_line: String in dialog_data:
		await write_text(
			current_dialog_line,
			dialog_data.get(current_dialog_line)
		)
		await get_tree().create_timer(3.5).timeout
		
		if not is_running(): break
	
	stop()


func stop() -> void:
	if _tween:
		_tween.kill()
	
	hide()
	label.text = ""
	_running = false
	ended.emit()
