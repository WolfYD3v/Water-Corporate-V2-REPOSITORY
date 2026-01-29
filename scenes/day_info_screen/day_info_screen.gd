extends Control
class_name DayInfoScreen

@onready var day_label: Label = $DayLabel
@onready var popup_timer: Timer = $PopupTimer

@export var popup_timer_waiting_time: float = 0.5

func _ready() -> void:
	hide()
	WorkingDaysManager.day_info_screen_scene = self

func _update_infos() -> void:
	day_label.text = "DAY " + str(WorkingDaysManager.get_working_days_count())

func popup() -> void:
	_update_infos()
	show()
	
	popup_timer.start(popup_timer_waiting_time)
	await popup_timer.timeout
	
	hide()
