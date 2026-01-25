extends BaseMachine
class_name PumpingStation

@onready var water_source: WaterSource = $WaterSource
@onready var status_rich_text_label: RichTextLabel = $ScreenSubViewport/Interface/NODES/StatusRichTextLabel

@onready var water_pump_progress_bar: ProgressBar = $ScreenSubViewport/Interface/NODES/Sections/WaterPumpSection/WaterPumpProgressBar
@onready var power_bank_progress_bar: ProgressBar = $ScreenSubViewport/Interface/NODES/Sections/PowerBankSection/PowerBankProgressBar
@onready var water_pump_rich_text_label: RichTextLabel = $ScreenSubViewport/Interface/NODES/Sections/StatisticsSection/WaterPusmpRichTextLabel

@export var player_interaction_allow: bool = false:
	set(value):
		player_interaction_allow = value
		# RESTE CODE ICI

enum STATUS {
	LOADING,
	READY,
	PUMPING,
	FREEING
}
var status: STATUS = STATUS.READY

var water_litters_pump_per_cession: float = 0.0:
	set(value):
		water_litters_pump_per_cession = value
		water_pump_rich_text_label.text = "[b][u]Water Pump:[/u][/b]" + "\n" + str(value) + " L"
var water_litters_max_pump_per_cession: float = 1.5
var pumping_speed: float = 5.0
var power_bank_capacity_per_cession: float = 150.0
var power_bank_filling_speed: float = 8.0
var _power_bank_ergonomy: float = 350.0 # Garder ou pas?

var _tween
var do_something: bool = false:
	set(value):
		do_something = value
		print(to_string(), ": Am I doin' something?...    ", do_something)
		print("STATUS: ", str(STATUS.keys()[status]))

func _ready() -> void:
	UpgradesData.upgrade_value_changed.connect(change_values_temp)
	key_to_press_label.hide()
	
	#print(UpgradesData.get_upgrades_list())
	
	water_litters_pump_per_cession = 0.0
	water_pump_progress_bar.value = 0.0
	power_bank_progress_bar.value = 100.0
	set_status(STATUS.READY)

func act() -> void:
	player_interaction_allow = not(player_interaction_allow)
	if action == ACTIONS.PUMP_WATER:
		print("Je vais pomper de l'eau!!!!")

func set_status(new_status: STATUS) -> void:
	status = new_status
	status_rich_text_label.text = "[b][u]STATUS:[/u] " + str(
		STATUS.keys()[status]
	) + "[/b]"

func _pump_water() -> void:
	if power_bank_progress_bar.value <= 0.0 or do_something: return
	
	set_status(STATUS.PUMPING)
	water_litters_pump_per_cession = 0.0
	do_something = true
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.finished.connect(_stop_pumping)
	_tween.tween_property(water_pump_progress_bar, "value", 100.0, pumping_speed)
	_tween.set_parallel()
	_tween.tween_property(self, "water_litters_pump_per_cession", water_litters_max_pump_per_cession, pumping_speed)
	_tween.set_parallel()
	_tween.tween_property(power_bank_progress_bar, "value", 0.0, pumping_speed + 1.0) # TEMP DURATION

func _stop_pumping() -> void:
	do_something = false
	if _tween:
		_tween.kill()

func _free_water_in_pipes() -> void:
	if water_pump_progress_bar.value <= 0.0 or do_something: return
	
	set_status(STATUS.FREEING)
	do_something = true
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.finished.connect(_load_power_bank)
	_tween.tween_property(water_pump_progress_bar, "value", 0.0, pumping_speed)
	_tween.set_parallel()
	_tween.tween_property(self, "water_litters_pump_per_cession", 0.0, pumping_speed)

func _load_power_bank() -> void:
	set_status(STATUS.LOADING)
	do_something = true
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.finished.connect(_stop_pumping)
	_tween.tween_property(power_bank_progress_bar, "value", 100.0, pumping_speed + 1.0) # TEMP DURATION

func _input(event: InputEvent) -> void:
	if not event is InputEventKey or not player_interaction_allow: return
	
	if Input.is_key_pressed(KEY_UP):
		_pump_water()
	if Input.is_key_pressed(KEY_DOWN):
		_stop_pumping()
		GlobalVariables.water_pumped += water_litters_pump_per_cession
		print(GlobalVariables, ": Total liters Water Pump...   ", GlobalVariables.water_pumped)
		_free_water_in_pipes()


func _on_power_bank_progress_bar_value_changed(value: float) -> void:
	if value <= 0:
		_stop_pumping()
	if value >= 100.0:
		set_status(STATUS.READY)
