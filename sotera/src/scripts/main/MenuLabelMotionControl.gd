extends Label

class_name MenuLabelMotionControl

var motion: CameraMotion = CameraMotion.new()
var base_offset: Vector2

func _init_motion() -> void:
	base_offset = position
	motion.enable_scale = false
	motion.enable_offset = true
	motion.enable_rotation = false
	
func _ready() -> void:
	_init_motion()
	
func _process(delta: float) -> void:
	var dict: Dictionary = motion.get_motion(delta)
	position = base_offset + dict["offset"]
