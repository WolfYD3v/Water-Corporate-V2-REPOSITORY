extends Node

signal scan_finished

var _industrial_lights_array: Array[IndustrialLight] = []
var _speakers_array: Array[Speaker] = []
var _nodes_scaned: int = 0

var _alerting: bool = false

func _ready() -> void:
	_industrial_lights_array.clear()

func list_nodes_for_alert_from(scan_starting_node: Node) -> void:
	for child_node: Node in scan_starting_node.get_children(true):
		_scan_node(child_node)
	
	print(_industrial_lights_array)
	print(_speakers_array)
	print(_nodes_scaned)
	scan_finished.emit()

func _scan_node(node: Node) -> void:
	if node is IndustrialLight: _industrial_lights_array.append(node)
	if node is Speaker: _speakers_array.append(node)
	
	_nodes_scaned += 1
	if node.get_child_count() > 0:
		for child_node: Node in node.get_children():
			_scan_node(child_node)



func _check_if_essential_arrays_are_empty() -> bool:
	return _industrial_lights_array.is_empty() or _speakers_array.is_empty()

func is_alerting() -> bool:
	return _alerting

func alert() -> void:
	if _check_if_essential_arrays_are_empty() and not is_alerting():
		return
	_alerting = true
	for _industrial_light: IndustrialLight in _industrial_lights_array:
		_industrial_light.can_flicker = false
	for _speaker: Speaker in _speakers_array:
		_speaker.play_sound("res://assets/musics/Badly (feat. Camellia).mp3")

func stop() -> void:
	if _check_if_essential_arrays_are_empty() and is_alerting():
		return
	for _industrial_light: IndustrialLight in _industrial_lights_array:
		_industrial_light.can_flicker = true
	for _speaker: Speaker in _speakers_array:
		_speaker.stop()
	_alerting = false
