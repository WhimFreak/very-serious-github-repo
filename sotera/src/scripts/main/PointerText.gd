extends Node2D

class_name PointerText

var _linked_text_btn: ColorRect
@export var range_padding_x: Vector2 = Vector2(8.0, 14.0)
@export var range_scale: Vector2 = Vector2(0.8, 1.2)
@export var left_pointer: Node2D
@export var right_pointer: Node2D

enum PointerTextState { HIDDEN, VISIBLE }

var _state: PointerTextState = PointerTextState.HIDDEN
var _padding_x: float

func _ready() -> void:
	# change visibility here so prefab example is still visible
	left_pointer.visible = false
	right_pointer.visible = false
	
func _process(delta: float) -> void:
	if _state == PointerTextState.HIDDEN: return
	_update()
	
func _update() -> void:
	# ------------------ new params -----------------------
	var box_scale: Vector2 = _linked_text_btn.scale
	var box_position: Vector2 = _linked_text_btn.position
	var box_size: Vector2 = _linked_text_btn.size
	box_size.x *= box_scale.x # works on copy
	box_size.y *= box_scale.y # works on copy
	var box_center_y: float = box_position.y + box_size.y * 0.5
	# ------------------ new params -----------------------
	
	# -------------------- current params ----------------------
	var size: Vector2 = left_pointer.texture.get_size()
	# -------------------- current params ----------------------
	
	
	var y: float = box_center_y - size.y * 0.5
	
	left_pointer.position.x = box_position.x - size.x - _padding_x
	left_pointer.position.y = y
	right_pointer.position.x = box_position.x + box_size.x + _padding_x
	right_pointer.position.y = y
	
func point(liked_text_btn: ColorRect, target_color: Color) -> void:
	self._linked_text_btn = liked_text_btn
	
	_padding_x = randf_range(range_padding_x.x, range_padding_x.y)
	
	# setting different color based on input
	left_pointer.modulate = target_color
	right_pointer.modulate = target_color
	
	# random size -> more rng/dynamic on small parts
	var ns: float = randf_range(range_scale.x, range_scale.y)
	left_pointer.scale = Vector2(ns, ns)
	right_pointer.scale = Vector2(ns, ns)
	
	left_pointer.visible = true
	right_pointer.visible = true
	_state = PointerTextState.VISIBLE
	
func hide_pointers() -> void:
	_linked_text_btn = null
	left_pointer.visible = false
	right_pointer.visible = false
	_state = PointerTextState.HIDDEN
	
