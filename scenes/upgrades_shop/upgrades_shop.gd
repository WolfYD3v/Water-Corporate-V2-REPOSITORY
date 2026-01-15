extends Control
class_name UpgradesShop

@export var upgrades_avaible: Array[Upgrade] = []

@onready var upgrades_cards_container: HBoxContainer = $NODES/UpgradesCardsContainer
@onready var money_label: Label = $NODES/MoneyLabel

func _ready() -> void:
	MoneyManager.money_updated.connect(update_money_display)
	update_money_display()
	hide()
	
	show()
	
	var upg_card_idx: int = 0
	for upg_card: UpgradeCard in upgrades_cards_container.get_children():
		upg_card.linked_upgrade = upgrades_avaible[upg_card_idx]
		upg_card_idx += 1

func update_money_display() -> void:
	money_label.text = str(MoneyManager.send_money()) + " $"
