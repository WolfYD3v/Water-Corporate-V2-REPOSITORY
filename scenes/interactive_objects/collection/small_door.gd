extends BaseInteractiveObjects
class_name SmallDoor

func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if GlobalVariables.player:
			player = GlobalVariables.player
		if interaction_timer.is_stopped() and player and mouse_focused:
			interaction_timer.start(interaction_timer_waiting_time)
			if not WorkingDaysManager.is_shift_started():
				says_smth()
				return
			
			print("DEV NOTE - End day here...")
			player.can_move = false
			player.can_rotate = false
			await get_tree().create_timer(2.5).timeout
			player.can_move = true
			player.can_rotate = true
			WorkingDaysManager.set_shift_can_start(true)

func says_smth() -> void:
	GlobalVariables.dialog_scene.stop()
	GlobalVariables.dialog_scene.show()
	if GlobalVariables.dialog_scene:
		if not WorkingDaysManager.is_shift_started():
			await GlobalVariables.dialog_scene.write_text(
				"You",
				"My shift is not started yet."
			)
		if WorkingDaysManager.is_shift_started():
			await GlobalVariables.dialog_scene.write_text(
				"You",
				"My shift is not done yet."
			)
		if not WorkingDaysManager._shift_can_start:
			await GlobalVariables.dialog_scene.write_text(
				"You",
				"I should go to sleep."
			)
	await get_tree().create_timer(2.0).timeout
	GlobalVariables.dialog_scene.hide()
