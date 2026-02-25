extends Control
class_name UpgradeCard

@export var upgrade: Upgrade = null
@export var description: String = "{DESCRIPTION}"

@onready var name_rich_text_label: RichTextLabel = $VBoxContainer/NameRichTextLabel
@onready var description_label: Label = $VBoxContainer/DescriptionLabel
@onready var price_label: Label = $VBoxContainer/PriceLabel
@onready var buy_button: Button = $BuyButton

func _ready() -> void:
	UpgradesData.upgrade_value_changed.connect(_update_upgrade_resource_level)
	if upgrade: update_display()

func update_display() -> void:
	name_rich_text_label.text = "[b]" + upgrade.upgrade_name + "[/b]"
	description_label.text = description
	price_label.text = str(upgrade.base_price) + " $" + "\n" + "LEVEL " + str(upgrade.get_level())
	buy_button.disabled = MoneyManager.send_money() < 0.0

func _on_buy_button_pressed() -> void:
	if MoneyManager.remove_money(upgrade.base_price):
		upgrade.level_up()
		update_display()
		update_data()

func update_data() -> void:
	UpgradesData.override_or_add_upgrade_data(
		upgrade.upgrade_scope,
		upgrade.get_level()
	)
	print(UpgradesData.get_upgrades_data())

func _update_upgrade_resource_level(upgrade_targeted: UpgradesData.UPGRADES, level_to_set: int) -> void:
	if upgrade_targeted == upgrade.upgrade_scope:
		upgrade.set_level(level_to_set)
		print("Upgrade " + str(upgrade.upgrade_scope) + " | LEVEL " + str(upgrade.get_level()))
