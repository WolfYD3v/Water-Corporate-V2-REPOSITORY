extends Node

signal upgrade_value_changed(upgrade: UPGRADES, upgrade_value: int)

enum UPGRADES {
	PUMPING_SPEED,
	WATER_PUMP_MAX,
	POWER_BANK_CAPACITY,
	POWER_BANK_FILLING_SPEED
}

var _upgrades_data: Dictionary[UPGRADES, int] = {}

func get_upgrade_data(upgrade: UPGRADES) -> int:
	if _upgrades_data.has(upgrade):
		return _upgrades_data.get(upgrade)
	return -1

func override_or_add_upgrade_data(upgrade: UPGRADES, new_value: int) -> void:
	_upgrades_data.set(upgrade, new_value)
	upgrade_value_changed.emit(upgrade, new_value)

func get_upgrades_list() -> Array:
	return _upgrades_data.keys()
