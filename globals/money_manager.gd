extends Node

signal money_updated
signal balance_is_negative

var _money: float = 150.0:
	set(value):
		_money = value
		money_updated.emit()

func send_money() -> float:
	return _money

func add_money(amount: float) -> void:
	_money += amount

# Now the player can have a negative balance, cool right?
# It's funny to have this kind of freedom ;)
func remove_money(amount: float) -> bool:
	if _money >= 0.0:
		_money = snappedf(_money - amount, 0.01)
		
		if _money < 0.0:
			balance_is_negative.emit()
		
		return true
	return false
