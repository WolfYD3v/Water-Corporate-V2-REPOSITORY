extends Control
class_name DialogScene

@onready var label: Label = $Label

var _tween

func _ready() -> void:
	hide()
	label.text = ""

func write_text(_who: String, _text: String) -> void:
	label.text = _who + "\n" + "\n" + _text
	label.visible_ratio = 0.0
	
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.tween_property(label, "visible_ratio", 1.0, 1.0)
	await _tween.finished

func play_dialog(_dialog_data: Dictionary[String, String]) -> void:
	show()
	for _current_dialog_line: String in _dialog_data.keys():
		await write_text(
			_current_dialog_line,
			_dialog_data.get(_current_dialog_line)
		)
		await get_tree().create_timer(3.5).timeout
		
		hide()
		label.text = ""
