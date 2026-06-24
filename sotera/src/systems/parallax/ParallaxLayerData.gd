class_name ParallaxLayerData
extends RefCounted

# used to parse ParallaxLayerA data to ParallaxSystem runtime data

var node: Node2D
var depth: float
var origin: Vector2

func _init(_node: Node2D, _depth: float) -> void:
	node = _node
	depth = _depth
	origin = _node.position
