class_name CrtMotion

enum CrtDinamicState { NORMAL, DARKEN, DARK, LIGHTEN }
var _material: ShaderMaterial
var _state: CrtDinamicState = CrtDinamicState.NORMAL
var time: float
var max_time: float
var range_max_time: Vector2 = Vector2(0.7, 1.25)

var range_unifrom_max_distance: Vector2 = Vector2(0.8, 0.4)
var uniform_origin: Vector2
var focus_origin: Vector2

func _init(shader_holder: ColorRect) -> void:
	self._material = shader_holder.material
	self.uniform_origin = self._material.get_shader_parameter("pivot")

func update(delta: float) -> void:
	match(_state):
		CrtDinamicState.DARKEN: _update_darken(delta)
		CrtDinamicState.LIGHTEN: _update_lighten(delta)

func _update_darken(delta: float) -> void:
	time = min(time + delta, max_time)
	_update_material()
	if time == max_time: _state = CrtDinamicState.DARK
	
func _update_lighten(delta: float) -> void:
	time = max(time - delta, 0)
	_update_material()
	if time == 0: _state = CrtDinamicState.NORMAL
	
func _update_material():
	var t: float = time / max_time
	var alpha: float = TweenUtils.ease_out_quart(t)
	
	# shader material disatce from center when color_edge.alpha == 1.0
	var dist: float = lerp(range_unifrom_max_distance.x, range_unifrom_max_distance.y, alpha)
	_material.set_shader_parameter("max_distance", dist)
	
	# shader/material center_pivot smooth follows new location. Origin is capped
	var target_origin: Vector2 = lerp(
		uniform_origin,
		focus_origin,
		alpha
	)
	self._material.set_shader_parameter("pivot", target_origin)
	
func start_darken(focus_origin: Vector2) -> void:
	self.focus_origin = focus_origin;
	time = 0.0
	max_time = randf_range(range_max_time.x, range_max_time.y)
	_state = CrtDinamicState.DARKEN

func start_lighten() -> void:
	_state = CrtDinamicState.LIGHTEN
	
func reset() -> void:
	_material.set_shader_parameter("max_distance", range_unifrom_max_distance.x) # default value
	_state = CrtDinamicState.NORMAL
