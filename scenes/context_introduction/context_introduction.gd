extends Control
class_name ContextIntroduction

signal finished

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	hide()
	
	play()

func play() -> void:
	label.visible_ratio = 0.0
	show()
	
	animation_player.play("play")
	await animation_player.animation_finished
	
	hide()
	finished.emit()
