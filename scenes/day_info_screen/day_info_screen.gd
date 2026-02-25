extends Control
class_name DayInfoScreen

@onready var day_label: Label = $DayLabel
@onready var popup_timer: Timer = $PopupTimer
@onready var hour_label: Label = $HourLabel
@onready var sfx_audio_stream_player: AudioStreamPlayer = $SFXAudioStreamPlayer
@onready var pixalation_shader_overlay: PixalationShaderOverlay = $PixalationShaderOverlay

@export var popup_timer_waiting_time: float = 3.5

func _ready() -> void:
	hide()
	WorkingDaysManager.day_info_screen_scene = self
	WorkingDaysManager.time_updated.connect(_update_hour_label)

func _update_hour_label() -> void:
	if visible:
		hour_label.text = WorkingDaysManager.get_time()

func _update_infos() -> void:
	day_label.text = "DAY " + str(WorkingDaysManager.get_working_days_count())

func popup() -> void:
	pixalation_shader_overlay.animated = true
	_update_infos()
	show()
	
	popup_timer.start(popup_timer_waiting_time)
	sfx_audio_stream_player.play()
	await popup_timer.timeout
	sfx_audio_stream_player.stop()
	
	pixalation_shader_overlay.animated = false
	hide()
