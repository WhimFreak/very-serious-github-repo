extends Node2D

@onready var label: Label = $"Control/Label"
@onready var LeverSprite: Sprite2D = $"Lever"

func _on_area_2d_body_entered(body: Node2D) -> void:
	label.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	label.visible = false

func LeverPulled():
	LeverSprite.flip_h = true
