extends Node

signal water_quota_updated

var water_quota: float = 10.0:
	set(value):
		water_quota = value
		water_quota_updated.emit()
var pumping_time: float = 300.0

var heating_time: float = 150.0
