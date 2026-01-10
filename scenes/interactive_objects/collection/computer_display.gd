extends Control
class_name ComputerDisplay

@export_range(1, 45) var max_desktop_icons_number: int = 45

@onready var desktop_icons: GridContainer = $DesktopInterface/DesktopIcons
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass

func add_desktop_icon() -> void:
	if desktop_icons.get_child_count() <= max_desktop_icons_number:
		pass

func push_nodification(nod_title: String, nod_content: String) -> void:
	pass
