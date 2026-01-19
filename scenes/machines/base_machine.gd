extends BaseInteractiveObjects
class_name BaseMachine

enum ACTIONS {
	PUMP_WATER
}
@export var action: ACTIONS = ACTIONS.PUMP_WATER

# Override if a custom ready is needed
func _ready() -> void:
	pass

# Empty function to override to give a custom behavoir to inheritance scenes 
func act() -> void:
	# CUSTOM CODE HERE
	pass
