extends BaseMachine
class_name PumpingStation

@onready var water_source: WaterSource = $WaterSource
@onready var status_rich_text_label: RichTextLabel = $ScreenSubViewport/Interface/NODES/StatusRichTextLabel

@onready var water_pump_progress_bar: ProgressBar = $ScreenSubViewport/Interface/NODES/Sections/WaterPumpSection/WaterPumpProgressBar
@onready var power_bank_progress_bar: ProgressBar = $ScreenSubViewport/Interface/NODES/Sections/PowerBankSection/PowerBankProgressBar
@onready var water_pump_rich_text_label: RichTextLabel = $ScreenSubViewport/Interface/NODES/Sections/StatisticsSection/WaterPusmpRichTextLabel
@onready var lever: Node3D = $Lever

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
var inactivity_status_array: Array[STATUS] = [
	STATUS.FREEING,
	STATUS.LOADING
]

var water_litters_pump_per_cession: float = 0.0:
	set(value):
		water_litters_pump_per_cession = value
		water_pump_rich_text_label.text = "[b][u]Water Pump:[/u][/b]" + "\n" + str(value) + " L"
var _water_litters_max_pump_per_cession: float = 1.5
var _pumping_speed: float = 5.0
var _power_bank_capacity_per_cession: float = 150.0
var _power_bank_filling_speed: float = 8.0
#var _power_bank_ergonomy: float = 350.0 # | Garder ou pas?

var _tween
var do_something: bool = false:
	set(value):
		do_something = value
		print(to_string(), ": Am I doin' something?...    ", do_something)
		print("STATUS: ", str(STATUS.keys()[status]))

func _ready() -> void:
	player_interaction_allow = true
	
	UpgradesData.upgrade_value_changed.connect(change_values)
	key_to_press_label.hide()
	
	#print(UpgradesData.get_upgrades_list())
	
	water_litters_pump_per_cession = 0.0
	water_pump_progress_bar.value = 0.0
	power_bank_progress_bar.value = _power_bank_capacity_per_cession
	set_status(STATUS.READY)
	_move_lever(false)

func act() -> void:
	player_interaction_allow = not(player_interaction_allow)

func set_status(new_status: STATUS) -> void:
	status = new_status
	status_rich_text_label.text = "[b][u]STATUS:[/u] " + str(
		STATUS.keys()[status]
	) + "[/b]"

func _pump_water() -> void:
	if status in inactivity_status_array or power_bank_progress_bar.value <= 0 or do_something or water_source.is_empty(): return
	
	set_status(STATUS.PUMPING)
	water_litters_pump_per_cession = 0.0
	do_something = true
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.finished.connect(_stop_pumping)
	_tween.finished.connect(water_source.lower_water_level)
	_tween.tween_property(water_pump_progress_bar, "value", 100.0, _pumping_speed)
	_tween.set_parallel()
	_tween.tween_property(self, "water_litters_pump_per_cession", _water_litters_max_pump_per_cession, _pumping_speed)
	_tween.set_parallel()
	_tween.tween_property(power_bank_progress_bar, "value", 0.0, _pumping_speed + 1.0) # TEMP DURATION

func _stop_pumping() -> void:
	if status in inactivity_status_array: return
	do_something = false
	if _tween:
		_tween.kill()

func _free_water_in_pipes() -> void:
	if status in inactivity_status_array or water_pump_progress_bar.value <= 0 or do_something: return
	
	set_status(STATUS.FREEING)
	do_something = true
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.finished.connect(_load_power_bank)
	_tween.tween_property(water_pump_progress_bar, "value", 0.0, _pumping_speed)
	_tween.set_parallel()
	_tween.tween_property(self, "water_litters_pump_per_cession", 0.0, _pumping_speed)

func _load_power_bank() -> void:
	set_status(STATUS.LOADING)
	do_something = true
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.finished.connect(_stop_pumping)
	_tween.tween_property(power_bank_progress_bar, "value", _power_bank_capacity_per_cession, _power_bank_filling_speed)

func _input(event: InputEvent) -> void:
	if not event is InputEventKey or not player_interaction_allow: return
	
	if Input.is_key_pressed(KEY_UP):
		await _move_lever(true)
		_pump_water()
	if Input.is_key_pressed(KEY_DOWN):
		await _move_lever(false)
		_stop_pumping()
		
		if not status in inactivity_status_array:
			GlobalVariables.water_pumped += water_litters_pump_per_cession
			print(GlobalVariables, ": Total liters Water Pump...   ", GlobalVariables.water_pumped)
		_free_water_in_pipes()


func _on_power_bank_progress_bar_value_changed(value: float) -> void:
	if value <= 0:
		_stop_pumping()
	if value >= 100.0:
		set_status(STATUS.READY)

func _move_lever(turning_up: bool) -> void:
	if status in [STATUS.FREEING, STATUS.LOADING] and do_something: return
	do_something = true
	
	var rot_value: float = 0.0
	if turning_up:
		rot_value = -25
	else:
		rot_value = 25
	
	if _tween:
		_tween.kill()
	_tween = get_tree().create_tween()
	_tween.tween_property(lever.get_node("CSGBakedMeshInstance3D"), "rotation:x", deg_to_rad(rot_value), 1.0)
	await _tween.finished
	
	do_something = false

# WIP
func change_values(upgrade_sended: UpgradesData.UPGRADES, upgrade_value: int) -> void:
	if upgrade_sended in allowed_upgrades:
		print(upgrade_value)
		print(get(allowed_upgrades.get(upgrade_sended)))
		
		match upgrade_sended:
			UpgradesData.UPGRADES.PUMPING_SPEED:
				_pumping_speed -= 0.1
				return
			UpgradesData.UPGRADES.WATER_PUMP_MAX:
				return
			UpgradesData.UPGRADES.POWER_BANK_CAPACITY:
				return
			UpgradesData.UPGRADES.POWER_BANK_FILLING_SPEED:
				return
