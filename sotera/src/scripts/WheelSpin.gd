extends Node2D

enum WHEELSTATE {
	SPINNING,
	IDLE
}

var state: WHEELSTATE = WHEELSTATE.IDLE;
var offset: float = 0.0;
var spin_speed: float = 0.0;
var spin_time: float = 0.0;
var min_speed: float = 0.1;
var max_speed: float = 0.2;
var min_time: float = 3.0;
var max_time: float = 5.0;

var speed_multiplier: float = 0.0;

var items: Array[int] = [
	5, 10, 15, 20, 25, 30
]
var elapsed_spin_time = 0;

func _process(delta: float) -> void:
	if elapsed_spin_time < spin_time:
		speed_multiplier = 1.0 - lerp(
			0,
			1,
			TweenUtils.ease_out_quart(elapsed_spin_time / spin_time)
		);

		elapsed_spin_time += delta

		offset += speed_multiplier;
		offset = fmod(offset, 1.0);
	else:
		stop_spinning()

	var single_value_height_in_texture = 1.0 / items.size();
	var value_idx = (int(offset / single_value_height_in_texture) + (items.size()/2)) % items.size();

	$WheelTexture.material.set_shader_parameter("offset", offset);
	$WheelTexture.material.set_shader_parameter("number_of_values", items.size());
	$WheelTexture.material.set_shader_parameter("current_value", value_idx);

	$WheelValue.text = str(items[value_idx])

func _input(event):
	if event.is_action_pressed("interact"):
		start_spinning()

func start_spinning():
	if state == WHEELSTATE.IDLE:
		state = WHEELSTATE.SPINNING
		spin_speed = RandUtils.randf_range(min_speed, max_speed)
		spin_time = RandUtils.randf_range(min_time,max_time)
		elapsed_spin_time = 0
		$WheelSpinEffect.start_speedup()
		$WheelSpinEffect2.start_speedup()

func stop_spinning()->void:
	if state == WHEELSTATE.SPINNING:
		state = WHEELSTATE.IDLE
		$WheelSpinEffect.start_slowdown()
		$WheelSpinEffect2.start_slowdown()
