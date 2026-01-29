extends Node

# VARIABLES

# DATE
var _working_days_count: int = 0
var _hour: int = 0
var _minute: int = 0
var day_info_screen_scene: DayInfoScreen = null

# SHIFT
var _shift_started: bool = false
var _shift_can_start: bool = true



# DATE MANAGEMENT
func get_working_days_count() -> int:
	return _working_days_count

func get_time() -> String:
	var hour_string: String = str(_hour)
	var minute_string: String = str(_minute)
	var time_string: String = hour_string + ":" + minute_string
	
	return time_string

# SHIFT MANAGEMENT
func set_shift_can_start(value: bool) -> void:
	_shift_can_start = value

func is_shift_started() -> bool:
	return _shift_started

func start_shift() -> void:
	if _shift_can_start:
		_shift_started = true
		_working_days_count += 1
		if day_info_screen_scene:
			day_info_screen_scene.popup()
		return
	push_warning("Shift cannot start")

func end_shift() -> void:
	_shift_started = false
