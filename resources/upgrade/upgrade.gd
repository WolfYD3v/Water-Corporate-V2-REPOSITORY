extends Resource
class_name Upgrade

@export var upgrade_name: String = "UPG NAME"
@export var upgrade_scope: UpgradesData.UPGRADES = UpgradesData.UPGRADES.PUMPING_SPEED
@export var max_upgrade_level: int = 25
@export var automation_allow: bool = true
@export var unlock_automatition_upgrade_level: int = 15
@export var base_price: float = 0.0
@export_range(1.1, 2.5) var price_augmentation_rate: float = 1.1

var _level: int = 0
var _automation_enable: bool = false

func level_up() -> void:
	if _level + 1 <= max_upgrade_level:
		_level += 1
		base_price = snappedf(base_price * price_augmentation_rate, 0.01)
		
		if not _automation_enable and automation_allow and _level >= unlock_automatition_upgrade_level:
			print(to_string(), " is automated now")
			_automation_enable = true

func set_level(value: int) -> void:
	_level = value
func get_level() -> int:
	return _level

func is_automated() -> bool:
	return _automation_enable and automation_allow
