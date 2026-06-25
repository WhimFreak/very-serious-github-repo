# sound_pool autoload
extends Node

const _STREAM_COUNT : int = 64
const _MAX_TRIES : int = 10

# WHEEL
const WHEEL_START : AudioStream = preload("res://assets/audio/wheel_start_1.wav")
const WHEEL_STOP : AudioStream = preload("res://assets/audio/wheel_stop_1.wav")
const WHEEL_TICK_1 : AudioStream = preload("res://assets/audio/wheel_tick_1.wav")
const WHEEL_TICK_2 : AudioStream = preload("res://assets/audio/wheel_tick_1.wav") # TODO
const MINIGAME_SELECTED : AudioStream = preload("res://assets/audio/minigame_selected.wav")

const PLAYER_FOOTSTEP_1 : AudioStream = preload("res://assets/audio/sfx/joentnt-walk-on-grass-1-291984.mp3") # TODO
const PLAYER_FOOTSTEP_2 : AudioStream = preload("res://assets/audio/sfx/joentnt-walk-on-grass-1-291984.mp3") # TODO
const PLAYER_FOOTSTEPS : Array[AudioStream] = [
	PLAYER_FOOTSTEP_1,
	PLAYER_FOOTSTEP_2,
]

const JUMPSCARE_1 : AudioStream = preload("res://assets/audio/Jumpscare 1 fx (shava).wav") # TODO
const JUMPSCARE_2 : AudioStream = preload("res://assets/audio/Jumpscare 2 (shava).wav")
const JUMPSCARE : Array[AudioStream] = [
	JUMPSCARE_1,
	JUMPSCARE_2,
]

# UI
const UI_CLICK_1 : AudioStream = preload("res://assets/audio/ui_click_1.wav")
const UI_CLICK_2 : AudioStream = preload("res://assets/audio/ui_click_2.wav")
const UI_CLICK : Array[AudioStream] = [
	UI_CLICK_1,
	UI_CLICK_2,
]

const UI_SELECT_1 : AudioStream = preload("res://assets/audio/ui_select_1.wav")
const UI_SELECT_2 : AudioStream = preload("res://assets/audio/ui_select_1.wav") # TODO
const UI_SELECT : Array[AudioStream] = [
	UI_SELECT_1,
	UI_SELECT_2,
]

#

# Concurrency: how many sounds of the same type can play at the same time
const _SOUND_CONCURRENCY : Dictionary = {
	WHEEL_START : 1,
	WHEEL_STOP : 1,
} 

const _SOUND_DEFAULT_CONCURRENCY : int = 3

var _next_idx : int = 0
var _players : Array[AudioStreamPlayer]
var _last_played : Dictionary = {}

func _ready() -> void:
	for i in _STREAM_COUNT:
		var instance : AudioStreamPlayer = AudioStreamPlayer.new()
		_players.push_back(instance)
		add_child(instance)


func _get_max_concurrent(sound : AudioStream) -> int:
	if sound in _SOUND_CONCURRENCY:
		return _SOUND_CONCURRENCY[sound]
	
	# Separately check for sounds that are grouped with variants

	if sound in PLAYER_FOOTSTEPS:
		return 1

	return _SOUND_DEFAULT_CONCURRENCY


func play_sound(sound : AudioStream) -> void:
	var max_concurrent : int = _get_max_concurrent(sound)
	
	var playing_instances : Array[AudioStreamPlayer] = []
	for p in _players:
		if p.stream == sound and p.playing:
			playing_instances.append(p)
	
	# Stop oldest instance if at max concurrency
	if playing_instances.size() >= max_concurrent:
		playing_instances[0].stop()
	
	var num_tries : int = 0
	while num_tries < _MAX_TRIES:
		if not _players[_next_idx].playing:
			_players[_next_idx].stream = sound
			_apply_custom_sound_volume(_players[_next_idx], sound)
			_apply_pitch_modulation(_players[_next_idx], sound)
			_players[_next_idx].play()
			_next_idx = (_next_idx + 1) % _STREAM_COUNT
			break
		else:
			num_tries += 1
			_next_idx = (_next_idx + 1) % _STREAM_COUNT


func play_random_sound(sounds: Array) -> void:
	play_sound(sounds[randi() % sounds.size()])


func play_random_shuffled_sound(sounds: Array) -> void:
	var idx : int
	if sounds.size() > 1:
		var last = _last_played.get(sounds, -1)
		idx = randi() % (sounds.size() - 1)
		if idx >= last:
			idx += 1
	else:
		idx = 0
	_last_played[sounds] = idx
	play_sound(sounds[idx])


func stop_sound(sound : AudioStream) -> void:
	for p in _players:
		if p.stream == sound:
			p.stop()


func stop_all_sounds():
	for p in _players:
		p.stop()


# Volume control
func _apply_custom_sound_volume(player : AudioStreamPlayer, _sound : AudioStream) -> void:
	player.volume_db = 0.0
	if _sound == WHEEL_START:
		player.volume_db = randf_range(-8.0, -4.5)
	if _sound == WHEEL_STOP:
		player.volume_db = randf_range(-12.0, -8.5)
	if _sound == MINIGAME_SELECTED:
		player.volume_db = randf_range(-1.5, 0.5)
	if _sound in PLAYER_FOOTSTEPS:
		player.volume_db = randf_range(-11.0, -9.5)
	if _sound in UI_CLICK:
		player.volume_db = randf_range(-12.2, -9.8)
	if _sound in UI_SELECT:
		player.volume_db = randf_range(-12.2, -9.8)
	if _sound in JUMPSCARE:
		player.volume_db = randf_range(-3.0, 6.5)
	
	return


# Pitch control
func _apply_pitch_modulation(player : AudioStreamPlayer, _sound : AudioStream) -> void:
	if _sound == WHEEL_START:
		player.pitch_scale = randf_range(0.98, 1.02)
	if _sound == WHEEL_STOP:
		player.pitch_scale = randf_range(1.18, 1.21)
	if _sound == MINIGAME_SELECTED:
		player.pitch_scale = randf_range(0.91, 1.01)
	if _sound in PLAYER_FOOTSTEPS:
		player.pitch_scale = randf_range(0.91, 1.11)
	if _sound in UI_CLICK:
		player.pitch_scale = randf_range(0.64, 0.74)
	if _sound in UI_SELECT:
		player.pitch_scale = randf_range(0.64, 0.74)
	if _sound in JUMPSCARE:
		player.pitch_scale = randf_range(0.98, 1.1)
	
	return
