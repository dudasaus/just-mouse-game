extends CharacterBody2D

var rotational_velocity = 0.0
var rotate_acceleration = 2.5
# friction per second
var rotate_friction = 3.0
var max_rotational_speed = 15.0

var shoot_force = 0.0
var shoot_force_change = 1.0
var max_shoot_force = 15.0
var min_shoot_force = 0.0
# seconds to adjust shoot force
var shoot_timer = 1.5

enum Mode {
	UNKNOWN,
	ROTATING,
	SHOOTING,
	UNCONTROLLABLE,
}

var mode = Mode.ROTATING

func _physics_process(delta: float) -> void:
	if mode == Mode.ROTATING:
		if not Input.is_action_just_pressed("shoot_more"):
			rotate_during_frame(delta)
		else:
			enter_shoot_mode()

func rotate_during_frame(delta: float):
	var frame_rotate_accel = 0.0
	if Input.is_action_just_pressed("rotate_right"):
		if rotational_velocity < 0:
			rotational_velocity = 0
		else:
			frame_rotate_accel += rotate_acceleration
	if Input.is_action_just_pressed("rotate_left"):
		if rotational_velocity > 0:
			rotational_velocity = 0
		else:
			frame_rotate_accel -= rotate_acceleration
	if frame_rotate_accel != 0:
		rotational_velocity += frame_rotate_accel
	else:
		rotational_velocity = max(
			abs(rotational_velocity) - rotate_friction * delta, 0) \
			* sign(rotational_velocity)
	
	if rotational_velocity != 0:
		rotational_velocity = min(max_rotational_speed, abs(rotational_velocity)) * sign(rotational_velocity)
		rotation_degrees += rotational_velocity

func shoot_mode_frame(delta: float):
	pass

func enter_shoot_mode():
	rotational_velocity = 0
	shoot_force = 0
