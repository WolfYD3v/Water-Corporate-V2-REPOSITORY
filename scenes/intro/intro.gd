extends Node3D
class_name Intro

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play() -> void:
	get_tree().paused = true
	animation_player.play("intro")
	await animation_player.animation_finished
	get_tree().paused = false
	print("eeeeeee")
	process_mode = Node.PROCESS_MODE_INHERIT
	queue_free()
