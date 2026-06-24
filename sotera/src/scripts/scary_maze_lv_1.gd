extends Node2D

@onready var hp = 3


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _on_wall_area_body_entered(body: Node2D) -> void:
	# Player takes damage from walls
	hp -= 1
	print("player health: ", hp)
	if hp == 0:
		# Change to game over scene
		get_tree().change_scene_to_file("res://assets/scenes/FortuneWheelScene.tscn")

func _on_exit_area_body_entered(body: CharacterBody2D) -> void:
	# Exit to level 2 scene
	get_tree().change_scene_to_file("res://scary_maze_lv_2.tscn")
