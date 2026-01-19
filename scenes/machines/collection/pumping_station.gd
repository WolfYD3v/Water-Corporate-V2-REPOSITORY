extends BaseMachine
class_name PumpingStation

func act() -> void:
	if action == ACTIONS.PUMP_WATER:
		print("Je vais pomper de l'eau!!!!")
