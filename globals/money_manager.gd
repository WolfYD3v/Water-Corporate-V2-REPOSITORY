extends Node

signal money_updated

var _money: float = 150.0:
	set(value):
		_money = value
		money_updated.emit()

func send_money() -> float:
	return _money

func add_money(amount: float) -> void:
	_money += amount

func remove_money(amount: float) -> bool:
	if _money - amount >= 0.0:
		_money -= amount
		return true
	return false
