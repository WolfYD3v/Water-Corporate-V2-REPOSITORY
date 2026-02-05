extends Node

signal time_updated
signal shift_ended

# VARIABLES

# DATE
var _working_days_count: int = 0
var _hour: int = 0
var _minute: int = 0
var day_info_screen_scene: DayInfoScreen = null

# SHIFT
var _shift_started: bool = false
var _shift_can_start: bool = true
var _end_shift_hour: int = 8 #17



# DATE MANAGEMENT
func get_working_days_count() -> int:
	return _working_days_count
func set_working_days_count(value: int) -> void:
	_working_days_count = value

func get_time() -> String:
	var str_hour: String = str(_hour)
	if str_hour.length() < 2:
		str_hour = "0" + str_hour
	var str_minute: String = str(_minute)
	if str_minute.length() < 2:
		str_minute = "0" + str_minute
	
	return str_hour + ":" + str_minute

func _clock_time() -> void:
	await get_tree().create_timer(0.5).timeout
	# 60sec IRl <-> 0.5sec IN-GAME
	_minute += 1
	
	if _minute >= 60:
		_minute = 0
		_hour += 1
	
	time_updated.emit()
	if _shift_started and _hour < _end_shift_hour: _clock_time()
	else:
		_shift_can_start = false
		end_shift()

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
		_hour = 7
		_clock_time()
		return
	push_warning("Shift cannot start")

func end_shift() -> bool:
	if _hour >= _end_shift_hour:
		print("DONE!")
		_shift_started = false
		shift_ended.emit()
		SaveManager.override_current_save()
		return true
	return false
