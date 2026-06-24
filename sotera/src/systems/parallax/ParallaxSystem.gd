extends Node

class_name ParallaxSystem

@export var max_offset: float = 50.0

@export var layers: Array[ParallaxLayerA]

var _layer_groups: Dictionary
var _layer_data: Array

func _ready() -> void:
	_init_layers()

func _init_layers() -> void:
	_layer_groups.clear()
	_layer_data.clear()
	
	for layer: ParallaxLayerA in layers:
		if layer == null: continue
		
		var depth: int = layer.depth
		
		# add new group if does not exists
		if not _layer_groups.has(depth):
			_layer_groups[depth] = []
			
		_layer_groups[depth].append(layer)
		_layer_data.append(ParallaxLayerData.new(layer, depth)) # add element to list

	_layer_data.sort_custom(
		func(a, b): return a.depth < b.depth
	)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_update_parallax(event.position)

func _update_parallax(mouse_pos: Vector2) -> void:
	var viewport_size := get_viewport().get_visible_rect().size
	var normalized := (mouse_pos - viewport_size * 0.5) / (viewport_size * 0.5)
	
	for data: ParallaxLayerData in _layer_data:
		var target: Vector2 = data.origin - normalized * max_offset * data.depth
		data.node.position = target
