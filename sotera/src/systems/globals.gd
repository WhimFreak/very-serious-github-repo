extends Node

var Total_contracts: int = 0
var Lives: int = 4

func _ready() -> void:
	Events.collect_contract.connect(increment_contracts)
	Events.lose_life.connect(take_damage)

func take_damage() -> void:
	Lives -= 1
	if Lives == 0:
		SoundPool.play_sound(SoundPool.MINIGAME_FAIL)
		Events.change_level("res://assets/scenes/FortuneWheelScene.tscn")

func increment_contracts() -> void:
	Total_contracts += 1
