extends Control
class_name ComputerDisplay

@export_range(1, 45) var max_desktop_icons_number: int = 45
@export var mails_list: Dictionary[String, String] = {}

@onready var boot_black_fading: ColorRect = $BootBlackFading
@onready var os_logo_texture_rect: TextureRect = $BootBlackFading/OSLogoTextureRect

@onready var desktop_action_bar: Control = $DesktopInterface/DesktopActionBar

@onready var desktop_icons: GridContainer = $DesktopInterface/DesktopIcons
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var nodification_bubble: Control = $NodificationBubble
@onready var nodification_bubble_app_name_rich_text_label: RichTextLabel = $NodificationBubble/Labels/AppNameRichTextLabel
@onready var nodification_bubble_text_label: Label = $NodificationBubble/Labels/TextLabel

@onready var mail_client: Control = $MailClient
@onready var mails: ItemList = $MailClient/Mails
@onready var mail_content: RichTextLabel = $MailClient/MailContent

@onready var heat_bar: Control = $HeatBar
@onready var heat_progress_bar: ProgressBar = $HeatBar/BarsContainer/HeatProgressBar
@onready var water_pumped_label: Label = $HeatBar/WaterPumpedLabel
@onready var pumping_time_progress_bar: ProgressBar = $HeatBar/BarsContainer/PumpingTimeProgressBar

@onready var pumping_time_timer: Timer = $PumpingTimeTimer

@onready var upgrades_shop: UpgradesShop = $UpgradesShop

var water_pump: float = 0.0:
	set(value):
		water_pump = value
		water_pumped_label.text = str(value) + " / " + str(GlobalVariables.water_quota) + " L"
var heat_bar_tween
var pumping_time_bar_tween

var computer_scene: Computer = null

func _ready() -> void:
	computer_scene = get_parent().get_parent()
	boot_black_fading.show()
	os_logo_texture_rect.hide()
	desktop_icons.hide()
	GlobalVariables.water_quota_updated.connect(_set_water_quota_display)
	MoneyManager.balance_is_negative.connect(_low_balance_detected)
	desktop_action_bar.hide()
	nodification_bubble.hide()
	heat_bar.hide()
	mail_client.hide()
	
	boot_black_fading.hide()
	boot()

func start() -> void:
	await get_tree().create_timer(1.0).timeout
	await boot()
	_list_mails()
	GlobalVariables.water_quota = 80.0

func boot() -> void:
	await get_tree().create_timer(1.5).timeout
	os_logo_texture_rect.show()
	await get_tree().create_timer(2.5).timeout
	animation_player.play("boot_fade")
	computer_scene.speaker_play_sound("res://assets/sfxs/CMPTMisc_Demarrage d un ibook g4 (ID 0157)_LS.mp3", 0.0, 0.5)
	await animation_player.animation_finished
	await get_tree().create_timer(0.5).timeout
	desktop_action_bar.show()
	await get_tree().create_timer(0.2).timeout
	mail_client.show()
	await get_tree().create_timer(0.1).timeout
	desktop_icons.show()
	await get_tree().create_timer(0.2).timeout
	heat_bar.show()
	await get_tree().create_timer(0.2).timeout

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
	computer_scene.speaker_play_sound("res://assets/sfxs/CMPTMisc_Demarrage d un ibook g4 (ID 0157)_LS.mp3", 0.0, 1.0)


func _on_window_button_pressed() -> void:
	if not mails_list.has("About that..."):
		_add_mail("OS", "About that...", "Well... this button only send a mail... useless you may say but... it's better than having AI in your system don't you think?")


func _on_mails_item_selected(index: int) -> void:
	mail_content.text = mails_list[mails.get_item_text(index)]

func _set_water_quota_display() -> void:
	_add_mail("Data Center Team", "Water requested", "Our data center need " + str(GlobalVariables.water_quota) + " L more in " + str(GlobalVariables.pumping_time) + " seconds." + "\n" + "\n" + "Your Manager.")
	
	water_pump = 0.0
	heat_progress_bar.value = 0.0
	heat_progress_bar.modulate = Color(1.0, 1.0, 1.0, 1.0)
	pumping_time_progress_bar.value = GlobalVariables.heating_time
	
	_tween_heat_bar()
	_tween_pumping_time_bar()
	pumping_time_timer.start(35.0)

# CHANGE THIS FUNCTION!!!!!
func _tween_heat_bar() -> void:
	if heat_bar_tween:
		heat_bar_tween.kill()
	heat_bar_tween = get_tree().create_tween()
	heat_bar_tween.tween_property(heat_progress_bar, "value", 100.0, 35.0)

func _tween_pumping_time_bar() -> void:
	if pumping_time_bar_tween:
		pumping_time_bar_tween.kill()
	pumping_time_bar_tween = get_tree().create_tween()
	pumping_time_bar_tween.tween_property(pumping_time_progress_bar, "value", 0.0, GlobalVariables.heating_time)

func _on_pumping_time_timer_timeout() -> void:
	if water_pump < GlobalVariables.water_quota:
		print("WATER QUOTA NOT FULL!")

func _on_upgrades_shop_button_pressed() -> void:
	upgrades_shop.show()

func _low_balance_detected() -> void:
	_add_mail("Management Team", "Low balance detected", "It looks like your balance is negative." + "\n" + "Current amount of money: " + str(MoneyManager.send_money()) + "$. Pump water to get paid, and hopefully having a positive balance." + "\n" + "We put our entire trust in you in your success.")


func _on_heat_progress_bar_value_changed(value: float) -> void:
	if value >= 90.0:
		heat_progress_bar.modulate = Color(1.0, 0.0, 0.0, 1.0)
		if not AlertManager.is_alerting():
			AlertManager.alert()
	else:
		heat_progress_bar.modulate = Color(1.0, 1.0, 1.0, 1.0)
		if AlertManager.is_alerting():
			AlertManager.stop()
