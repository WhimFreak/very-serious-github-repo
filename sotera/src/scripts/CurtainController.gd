extends Node

class_name CurtainController

@export var range_min_max_little_db: Vector2 = Vector2(3.0, 6.0)
@export var range_min_max_full_db: Vector2 = Vector2(10.0, 13.2)
@onready var _sound: AudioStreamPlayer2D = $"Move Sound"

# TODO: determine what to do if sound is alredy playing
# TODO: adjust lound & sound length of full opening

# quiter sound
func start_little_sound() -> void:
	if _sound.playing:
		_sound.seek(_sound.get_playback_position() * 0.5) # try to reduce play by 50%
	else: _start_sound(range_min_max_little_db)

# more loud sound
func start_full_sound() -> void:
	_start_sound(range_min_max_full_db)
		
func _start_sound(range_db: Vector2) -> void:
	#_sound.pitch_scale = 0.2
	_sound.volume_db = randf_range(range_db.x, range_db.y)
	_sound.play(0.0)
