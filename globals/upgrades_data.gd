extends Node

signal upgrade_value_changed(upgrade: UPGRADES, upgrade_value: int)

enum UPGRADES {
	PUMPING_SPEED,
	WATER_PUMP_MAX,
	POWER_BANK_CAPACITY,
	POWER_BANK_FILLING_SPEED,
	AUTOMATION
}

var _upgrades_data: Dictionary = {}:
	set(value):
		_upgrades_data = value
		for upg: UPGRADES in _upgrades_data.keys():
			upgrade_value_changed.emit(upg, _upgrades_data[upg])

func set_upgrades_data(value: Dictionary) -> void:
	_upgrades_data = value
func get_upgrades_data() -> Dictionary:
	return _upgrades_data

func get_upgrade_data(upgrade: UPGRADES) -> int:
	if _upgrades_data.has(upgrade): return _upgrades_data.get(upgrade)
	return -1

func override_or_add_upgrade_data(upgrade: UPGRADES, new_value: int) -> void:
	_upgrades_data.set(upgrade, new_value)

func get_upgrades_list() -> Array:
	return _upgrades_data.keys()

func get_upgrades_data_dictionnary() -> Dictionary:
	return _upgrades_data
