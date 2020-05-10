extends KinematicBody

var gravity = -65
var velocity = Vector3()
var previous_speed = Vector3()
var strafe = {'left': Vector3(-1,0,0), 'idle': Vector3(), 'right': Vector3(1,0,0)}
var strafe_direction = strafe.idle

const STRAFE_BOUNDARY = 10
const F_SPEED = 50
const S_SPEED = 80
const ACCELERATION = 1
const DECELERATION = 3
const FRICTION = 0.1

var is_jumping = false
var is_powering_jump = false
var jump_power = 0
const MIN_JUMP_SPEED = 20
const MAX_JUMP_FORWARD_RATIO = 0.3
const MAX_JUMP_POWER = 20.0

func _physics_process(delta):
	move_player(delta)

func move_player(delta):
	velocity.y += delta * gravity
	var forward_velocity = move_forward(delta)
	var strafe_velocity = move_sideways()
	var jump_velocity = jump()
	
	velocity.z = forward_velocity.z
	velocity.y = jump_velocity.y
	velocity.x = strafe_velocity.x
	velocity = move_and_slide(velocity, Vector3.UP)

func move_forward(delta):
	var is_floored = is_on_floor()
	var forward_velocity = Vector3()
	
	if is_floored and Input.is_action_pressed("move_forward"):
		forward_velocity += Vector3.FORWARD
	elif is_floored and Input.is_action_pressed("move_stop"):
		forward_velocity = Vector3.BACK
	
	var fv = Vector3(0, 0, velocity.z)
	if is_floored:
		var new_pos = forward_velocity * F_SPEED
		previous_speed = new_pos
		var acceleration = DECELERATION
		if forward_velocity.dot(fv) > 0:
			acceleration = ACCELERATION
		
		fv = fv.linear_interpolate(new_pos, acceleration * delta)
	return fv

func move_sideways():
	var is_floored = is_on_floor()
	var slide_velocity = Vector3()
	
	if is_floored and Input.is_action_pressed("move_left"):
		strafe_direction = strafe.left
	elif is_floored and Input.is_action_pressed("move_right"):
		strafe_direction = strafe.right
	
	var target_pos = transform.origin
	target_pos.x = strafe_direction.x * STRAFE_BOUNDARY
	var target_velocity = target_pos - transform.origin
	slide_velocity = clamp_vector(target_velocity * S_SPEED, S_SPEED)
	return slide_velocity

func jump():
	var jump_speed = Vector3(0, velocity.y, 0)
	var is_floored = is_on_floor()
	if is_jumping and is_floored:
		is_jumping = false
		jump_power = 0
	
	if not is_floored:
		is_powering_jump = false
	
	if is_powering_jump:
		jump_power += 1
		jump_power = clamp(jump_power, 0, MAX_JUMP_POWER)
		#print('jump_power: ', jump_power)
	
	if not is_jumping and Input.is_action_just_pressed("jump"):
		is_powering_jump = true
	if not is_jumping and Input.is_action_just_released("jump"):
		is_powering_jump = false
		is_jumping = true
		jump_speed.y += calculate_jump_power(jump_speed)
	return jump_speed

func calculate_jump_power(jump_speed):
	var vertical_speed = jump_speed.y
	var speed_ratio = (jump_power/MAX_JUMP_POWER * MAX_JUMP_FORWARD_RATIO) * -velocity.z
	var power = (MIN_JUMP_SPEED + speed_ratio )
	vertical_speed += power
	print(vertical_speed, ' : ', jump_power)
	return vertical_speed

func clamp_vector(vector, length):
	var norm = vector.normalized()
	if vector.length() > length:
		vector = norm * length
	return vector