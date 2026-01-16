extends Resource
class_name Upgrade

@export var upgrade_name: String = ""
@export var upgrade_scope: UpgradesData.UPGRADES = UpgradesData.UPGRADES.TEST
@export var max_upgrade_level: int = 25
@export var unlock_automatition_upgrade_level: int = 15
@export var base_price: float = 0.0
@export_range(1.1, 1.5) var price_augmentation_rate: float = 1.1

var _level: int = 0
var _automation_enable: bool = false

func level_up() -> void:
	if _level + 1 <= max_upgrade_level:
		_level += 1
		base_price = snappedf(base_price * price_augmentation_rate, 0.01)

func get_level() -> int:
	return _level

func is_automated() -> bool:
	return _automation_enable
