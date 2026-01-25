extends BaseInteractiveObjects
class_name BaseMachine

enum ACTIONS {
	PUMP_WATER
}
@export var action: ACTIONS = ACTIONS.PUMP_WATER
@export var allowed_upgrades: Array[String] = []

# Override if a custom ready is needed
func _ready() -> void:
	UpgradesData.upgrade_value_changed.connect(change_values_temp)
	key_to_press_label.hide()

# Empty function to override to give a custom behavoir to inheritance scenes 
func act() -> void:
	# CUSTOM CODE HERE
	pass

func change_values_temp(a: String, b: int) -> void:
	if a in allowed_upgrades:
		print(b)
