extends Node

signal upgrade_value_changed(upgrade_name: String, upgrade_value: int)

enum UPGRADES {
	TEST
}

var _upgrades_data: Dictionary[String, int] = {}

func get_upgrade_data(upgrade_name: String) -> int:
	if _upgrades_data.has(upgrade_name):
		return _upgrades_data.get(upgrade_name)
	return -1

func override_or_add_upgrade_data(upgrade_name: String, new_value: int) -> void:
	_upgrades_data.set(upgrade_name, new_value)
	upgrade_value_changed.emit(upgrade_name, new_value)

func get_upgrades_list() -> Array:
	return _upgrades_data.keys()
