extends Node3D
class_name Intro

signal finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera: Camera3D = $Camera
@onready var black_fading: ColorRect = $CanvasLayer/BlackFading
@onready var text_label: Label = $CanvasLayer/TextLabel

enum TEXT_LABEL_POSITIONS {
	TOP_LEFT = 1,
	TOP_RIGHT = 2,
	BOTTOM_LEFT = 3,
	BOTTOM_RIGHT = 4
}

func _ready() -> void:
	hide()
	black_fading.hide()
	#process_mode = Node.PROCESS_MODE_ALWAYS
	#play()

func play() -> void:
	show()
	black_fading.show()
	get_tree().paused = true
	animation_player.play("intro")
	await animation_player.animation_finished
	get_tree().paused = false
	process_mode = Node.PROCESS_MODE_INHERIT
	finished.emit()
	queue_free()

func write_text(text: String = "", text_label_position: TEXT_LABEL_POSITIONS = TEXT_LABEL_POSITIONS.TOP_LEFT) -> void:
	match text_label_position:
		TEXT_LABEL_POSITIONS.TOP_LEFT: text_label.set_anchors_preset(Control.PRESET_TOP_LEFT)
		TEXT_LABEL_POSITIONS.TOP_RIGHT: text_label.set_anchors_preset(Control.PRESET_TOP_RIGHT)
		TEXT_LABEL_POSITIONS.BOTTOM_LEFT: text_label.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
		TEXT_LABEL_POSITIONS.BOTTOM_RIGHT: text_label.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	
	text_label.text = text
	text_label.visible_ratio = 0.0
	
	while text_label.visible_ratio < 1.0:
		text_label.visible_ratio += 0.01
		await get_tree().create_timer(0.01).timeout
