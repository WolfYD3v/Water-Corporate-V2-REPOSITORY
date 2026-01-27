extends BaseInteractiveObjects
class_name BaseMachine

@export var allowed_upgrades: Dictionary[UpgradesData.UPGRADES, String] = {}

# Override if a custom ready is needed
func _ready() -> void:
	UpgradesData.upgrade_value_changed.connect(change_values)
	key_to_press_label.hide()

# Empty function to override to give a custom behavoir to inheritance scenes 
func act() -> void:
	# CUSTOM CODE HERE
	pass

# Override to change properly the values
func change_values(upgrade_sended: UpgradesData.UPGRADES, upgrade_value: int) -> void:
	if upgrade_sended in allowed_upgrades:
		print(upgrade_value)
		print(get(allowed_upgrades.get(upgrade_sended)))
		
		#match upgrade_sended:
			# CODE ICI
