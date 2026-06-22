extends Control

@export var target_scene: String

func _on_play_pressed() -> void:
	print("hello")
	get_tree().change_scene_to_file(target_scene)


func _on_volume_slider_value_changed(value: float) -> void:
	# set master volume using scroll
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func transition_to(scene_path: String, speed_scale: float = 1):
	# Set animation speed
	animation_player.speed_scale = speed_scale
	
	# Fade to black
	animation_player.play("fade_to_black")
	
	# Wait until screen is black
	await animation_player.animation_finished
	
	# Change scene
	get_tree().change_scene_to_file(scene_path)
	
	# Fade back in once scene is changed
	animation_player.play_backwards("fade_to_black")
