extends Control
class_name UpgradesShop

@onready var upgrades_cards_container: HBoxContainer = $NODES/UpgradesCardsContainer
@onready var money_rich_text_label: RichTextLabel = $NODES/MoneyRichTextLabel
@onready var automate_update_card: UpgradeCard = $NODES/UpgradesCardsContainer/AutomateUpdateCard

func _ready() -> void:
	MoneyManager.money_updated.connect(update_money_display)
	UpgradesData.upgrade_value_changed.connect(a)
	update_money_display()
	hide()
	
	#show()
	for upgrade_card: UpgradeCard in upgrades_cards_container.get_children():
		upgrade_card.update_display()
		automate_update_card.visible = UpgradesData.get_upgrade_data(
			UpgradesData.UPGRADES.PUMPING_SPEED
		) >= 2

func update_money_display() -> void:
	money_rich_text_label.text = "[b][u]" + str(MoneyManager.send_money()) + " $" + "[/u][/b]"
	
	for upgrade_card: UpgradeCard in upgrades_cards_container.get_children():
		upgrade_card.update_display()
		automate_update_card.visible = UpgradesData.get_upgrade_data(
			UpgradesData.UPGRADES.PUMPING_SPEED
		) >= 2

func _on_close_button_pressed() -> void:
	hide()

func a(_a, _b) -> void:
	update_money_display()
