extends Node

signal water_quota_updated
signal water_pumped_updated

var player: Player = null
var map: Map = null
var dialog_scene: DialogScene = null
var shadox_ai_infos: ShadowAI_Infos = ShadowAI_Infos.new()

func _ready() -> void:
	shadox_ai_infos.set_gpus_usage()
	print("Water Quota Calculated: ", shadox_ai_infos.calculate_water_quota())

var water_pumped: float = 0.0:
	set(value):
		water_pumped = value
		water_pumped_updated.emit()
var water_quota: float = 10.0:
	set(value):
		water_quota = value
		water_quota_updated.emit()
var pumping_time: float = 300.0

var heating_time: float = 150.0

var tutorial_done: bool = false

# Merci Gemini ;)
class ShadowAI_Infos:
	# Paramètres de difficulté (peuvent être ajustés)
	var ai_complexity: float = 1.0         # Augmente au fil du jeu (IA plus "intelligente")
	var gpu_capacity: float = 100.0        # Capacité de calcul d'un seul GPU
	var water_multiplier: float = 50.0     # Litres d'eau par % d'usage
	var user_count: int = 3:               # Testers count at 3, active users at +3
		set(value):
			user_count = value
			set_gpus_usage()
	var gpu_count: int = 5:
		set(value):
			gpu_count = value
			set_gpus_usage()
	var gpus_usage: float = 0.0
	
	func set_gpus_usage() -> void:
		if gpu_count > 0:
			# On calcule la charge totale divisée par la capacité totale des GPUs
			var total_capacity = gpu_count * gpu_capacity
			var total_load = user_count * ai_complexity
			gpus_usage = (total_load / total_capacity) * 100.0
		else: gpus_usage = 100.0 # Sans GPU, tout surchauffe immédiatement !
		gpus_usage = clampf(gpus_usage, 0.0, 100.0)
	
	func calculate_water_quota() -> float:
		set_gpus_usage()
		# Le quota est basé sur l'usage. 
		# Plus l'IA est sollicitée, plus le volume d'eau demandé est grand.
		var quota = gpus_usage * water_multiplier
		
		return quota
