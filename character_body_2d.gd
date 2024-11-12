extends CharacterBody2D

var rotational_velocity = 0.0
var rotate_acceleration = 2.5
# friction per second
var rotate_friction = 3.0
var max_rotational_speed = 15.0

var shoot_force: float = 0.0
var shoot_force_change = 45.0
var max_shoot_force = 3000.0
var min_shoot_force = 0.0
# seconds to adjust shoot force
var shoot_time_seconds = 1.5
var shoot_timer = 0.0

var friction = 1.0
var min_velocity = 1.0

enum Mode {
	UNKNOWN,
	ROTATING,
	SHOOTING,
	ACTUALLY_MOVING,
	UNCONTROLLABLE,
}

var mode = Mode.ROTATING

func _physics_process(delta: float) -> void:
	rotate_during_frame(delta)
	shoot_mode_frame(delta)
	actually_moving_mode_frame(delta)
	#if mode == Mode.ROTATING:
		#if not Input.is_action_just_pressed("shoot_more"):
			#rotate_during_frame(delta)
		#else:
			#enter_shoot_mode()
	#elif mode == Mode.SHOOTING:
		#shoot_mode_frame(delta)
	#elif mode == Mode.ACTUALLY_MOVING:
		#actually_moving_mode_frame(delta)

func rotate_during_frame(delta: float):
	var frame_rotate_accel = 0.0
	if Input.is_action_just_pressed("rotate_right"):
		if rotational_velocity < 0:
			rotational_velocity = 0
		#else:
		frame_rotate_accel += rotate_acceleration
	if Input.is_action_just_pressed("rotate_left"):
		if rotational_velocity > 0:
			rotational_velocity = 0
		#else:
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
	if Input.is_action_just_pressed("shoot_more"):
		shoot_force = min(shoot_force + shoot_force_change, max_shoot_force)
	if Input.is_action_just_pressed("shoot_less"):
		shoot_force = max(shoot_force - shoot_force_change, min_shoot_force)
	shoot_timer = max(shoot_timer - delta, 0)
	if shoot_timer == 0:
		velocity = Vector2.from_angle(rotation) * shoot_force
		mode = Mode.ACTUALLY_MOVING

func actually_moving_mode_frame(delta: float):
	if velocity == Vector2.ZERO:
		mode = Mode.ROTATING
		return
	move_and_slide()
	velocity = lerp(velocity, Vector2.ZERO, delta * friction)
	if (abs(velocity.x) < min_velocity &&
		abs(velocity.y) < min_velocity):
		velocity = Vector2.ZERO
	

func enter_shoot_mode():
	rotational_velocity = 0
	shoot_force = shoot_force_change
	mode = Mode.SHOOTING
	shoot_timer = shoot_time_seconds
