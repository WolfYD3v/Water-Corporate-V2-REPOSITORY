extends BaseRoom
class_name LivingRoom

func _send_change_room_area_trigger() -> void:
	if next_room_direction_idx >= 0 and $Timer.is_stopped():
		
		if not WorkingDaysManager.is_shift_started() and WorkingDaysManager._shift_can_start:
			says_smth()
			return
		
		print(to_string() + str(next_room_direction_idx))
		await get_tree().create_timer(0.1).timeout
		change_room.emit(next_room_direction_idx)

func says_smth() -> void:
	GlobalVariables.dialog_scene.stop()
	GlobalVariables.dialog_scene.show()
	if GlobalVariables.dialog_scene: 
		await GlobalVariables.dialog_scene.write_text(
			"You",
			"My shift is not started yet."
		)
	await get_tree().create_timer(2.0).timeout
	GlobalVariables.dialog_scene.hide()
