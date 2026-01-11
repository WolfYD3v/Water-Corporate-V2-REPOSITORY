extends Control
class_name ComputerDisplay

@export_range(1, 45) var max_desktop_icons_number: int = 45
@export var mails_list: Dictionary[String, String] = {}

@onready var desktop_icons: GridContainer = $DesktopInterface/DesktopIcons
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var nodification_bubble: Control = $NodificationBubble
@onready var nodification_bubble_app_name_rich_text_label: RichTextLabel = $NodificationBubble/Labels/AppNameRichTextLabel
@onready var nodification_bubble_text_label: Label = $NodificationBubble/Labels/TextLabel

@onready var mails: ItemList = $MailClient/Mails
@onready var mail_content: RichTextLabel = $MailClient/MailContent

func _ready() -> void:
	nodification_bubble.hide()
	boot()

func boot() -> void:
	_list_mails()
	await get_tree().create_timer(3.5).timeout
	_add_mail("CHARACTER", "Yo c'est moi :)", "Tu me connais non?")

func _add_desktop_icon() -> void:
	if desktop_icons.get_child_count() <= max_desktop_icons_number:
		pass

func _list_mails() -> void:
	mails.clear()
	for mail: String in mails_list.keys():
		mails.add_item(mail)
		await get_tree().create_timer(0.1).timeout

func _add_mail(sender: String, mail_name: String, mail_text: String) -> void:
	mails_list[mail_name] = sender + "\n" + mail_text
	_list_mails()
	_push_nodification("OktaMail Client", sender + " sended you a mail." + "\n" + "Please check your inbox to see it.")

func _push_nodification(app_name: String, nod_text: String) -> void:
	if animation_player.is_playing():
		animation_player.stop()
	nodification_bubble_app_name_rich_text_label.text = "[b]" + app_name + "[/b]"
	nodification_bubble_text_label.text = nod_text
	animation_player.play("nodification_bubble_anim")


func _on_window_button_pressed() -> void:
	_push_nodification("TEST APP", "TEST TEXT")
	pass


func _on_mails_item_selected(index: int) -> void:
	mail_content.text = mails_list[mails.get_item_text(index)]
