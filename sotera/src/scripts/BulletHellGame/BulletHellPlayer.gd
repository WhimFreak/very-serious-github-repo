extends Player
class_name BulletHellPlayer

@export var gun: BulletHellGun
@export var iFrames: int

var currentiFrames: int = 0
var mousePos: Vector2
var theta = 0
var firing: bool = false

const up_left_theta:float = (-3)*PI/4
const up_right_theta:float = -PI/4
const down_right_theta = PI/4
const down_left_theta = 3*PI/4
const up_theta = -PI/2
const down_theta = PI/2

#Starting screen parameters
func _ready():
	super._ready()
	mousePos = get_global_mouse_position()
	
func idle_animation():
	if theta>down_right_theta && theta<down_left_theta:
		$Animations.play("forwardidle")
	if theta<up_right_theta&&theta>up_left_theta:
		$Animations.play("backidle")
	if theta > down_left_theta || theta<up_left_theta:
		$Animations.play("leftidle")
	if theta < down_right_theta && theta > up_right_theta:
		$Animations.play("rightidle")
		
func movement_animation():
	if velocity.x == 0 and velocity.y > 0:
		if theta > 0:
			$Animations.play("forwardrun")
		else:
			$Animations.play_backwards("backrun")
	elif velocity.x == 0 and velocity.y < 0:
		if theta>0:
			$Animations.play_backwards("forwardrun")
		else:
			$Animations.play("backrun")
	elif velocity.x > 0:
		if theta>up_theta && theta<down_theta:
			$Animations.play("rightrun")
			$Animations.flip_h = false
		else:
			$Animations.flip_h = true
			$Animations.play_backwards("leftrun")
	elif velocity.x < 0:
		if theta>up_theta && theta<down_theta:
			$Animations.play_backwards("rightrun")
			$Animations.flip_h = false
		else:
			$Animations.flip_h = true
			$Animations.play("leftrun")

func _physics_process(delta):
	if currentiFrames > 0:
		currentiFrames -= 1

	mousePos = get_global_mouse_position()
	theta = get_angle_to(mousePos)

	if Input.is_action_just_pressed("action"):
		gun.shoot(mousePos)
	super._physics_process(delta)

func takeDamage(damage:int) -> void:
	if currentiFrames <= 0:
		currentiFrames = iFrames
		Events.lose_life.emit()
		
