extends Node

signal save_loaded

var save_file_config: ConfigFile = ConfigFile.new()
var save_file_path: String = OS.get_user_data_dir() + "/save.cfg"
var save_file_data_loaded: Dictionary = {}

var base_save_data: Dictionary = {
	"tutorial_done": false,
	"days_count": 0,
	"actual_room_name": "ReceptionRoom(2,6)"}

func _ready() -> void:
	if not is_save_exist():
		create_save_file()

func is_save_exist() -> bool:
	return FileAccess.file_exists(save_file_path)

func load_save() -> void:
	var err = save_file_config.load(save_file_path)
	if err != OK:
		return
	
	for _current_data in base_save_data:
		save_file_data_loaded[_current_data] = save_file_config.get_value("SAVE_DATA", _current_data)
	GlobalVariables.tutorial_done = save_file_data_loaded["tutorial_done"]
	WorkingDaysManager.set_working_days_count(save_file_data_loaded["days_count"])
	#GlobalVariables.map.actual_room = GlobalVariables.map.rooms.get_node(save_file_data_loaded["actual_room_name"])
	
	save_loaded.emit()
	print(save_file_data_loaded)

func create_save_file() -> void:
	for _current_data in base_save_data:
		save_file_config.set_value("SAVE_DATA", _current_data, base_save_data.get(_current_data))
	save_file_config.save(save_file_path)

func override_current_save() -> void:
	var save_data_to_write: Dictionary = base_save_data.duplicate()
	save_data_to_write.set("tutorial_done", GlobalVariables.tutorial_done)
	save_data_to_write.set("days_count", WorkingDaysManager.get_working_days_count())
	print(GlobalVariables.map.actual_room.name)
	save_data_to_write.set("actual_room_name", GlobalVariables.map.actual_room.name)
	
	for _current_data in save_data_to_write:
		save_file_config.set_value("SAVE_DATA", _current_data, save_data_to_write.get(_current_data))
	save_file_config.save(save_file_path)

func delet_save_file() -> void:
	DirAccess.remove_absolute(save_file_path)

func get_save_data(wanted_value: String) -> Variant:
	if not save_file_data_loaded.has(wanted_value): return null
	return save_file_data_loaded.get(wanted_value)
