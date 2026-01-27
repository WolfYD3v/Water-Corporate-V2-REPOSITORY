extends Control
class_name UpgradeCard

@export var description: String = "{DESCRIPTION}"

@onready var name_rich_text_label: RichTextLabel = $VBoxContainer/NameRichTextLabel
@onready var description_label: Label = $VBoxContainer/DescriptionLabel
@onready var price_label: Label = $VBoxContainer/PriceLabel
@onready var buy_button: Button = $BuyButton

var linked_upgrade: Upgrade = null:
	set(value):
		linked_upgrade = value
		update_display()
		
		update_data()

func _ready() -> void:
	pass

func update_display() -> void:
	name_rich_text_label.text = "[b]" + linked_upgrade.upgrade_name + "[/b]"
	description_label.text = description
	price_label.text = str(linked_upgrade.base_price) + " $" + "\n" + "LEVEL " + str(linked_upgrade.get_level())
	buy_button.disabled = MoneyManager.send_money() < 0.0

func _on_buy_button_pressed() -> void:
	if MoneyManager.remove_money(linked_upgrade.base_price):
		linked_upgrade.level_up()
		update_display()
		update_data()

func update_data() -> void:
	UpgradesData.override_or_add_upgrade_data(
		linked_upgrade.upgrade_scope,
		linked_upgrade.get_level()
	)
	print(UpgradesData._upgrades_data)
