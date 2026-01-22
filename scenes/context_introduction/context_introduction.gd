extends Control
class_name ContextIntroduction

signal finished

@export var context_lines: Array[String] = []

@onready var label: Label = $Label

func _ready() -> void:
	hide()

func play() -> void:
	show()
	
	for line_str: String in context_lines:
		label.text = line_str
		await get_tree().create_timer(3.5).timeout
	
	await get_tree().create_timer(3.5).timeout
	hide()
	finished.emit()
