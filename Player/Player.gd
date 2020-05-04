extends KinematicBody

var gravity = -9.8
var velocity = Vector3()
var strafe = {'left': Vector3(-1,0,0), 'idle': Vector3(), 'right': Vector3(1,0,0)}
var strafe_direction = strafe.idle

const STRAFE_BOUNDARY = 10
const F_SPEED = 40
const S_SPEED = 80
const ACCELERATION = 3
const DECELERATION = 5

func _physics_process(delta):
	move_player(delta)

func move_player(delta):
	velocity.y += delta * gravity
	var forward_velocity = move_forward(delta)
	var strafe_velocity = move_sideways(delta)
	
	velocity.z = forward_velocity.z
	velocity.x = strafe_velocity.x
	velocity = move_and_slide(velocity, Vector3.UP)
	
#	var vel = run_player(delta)
#	var vel = strafe_player(delta)
#	var forward_velocity = vel.forward_velocity
#	strafe_direction = vel.strafe_direction
#
#	side_velocity += strafe_direction * S_SPEED 
#
#	velocity.y += delta * gravity
#	var hv = velocity
#	hv.y = 0
#	var new_pos = (forward_velocity * F_SPEED)
#	var acceleration = DECELERATION
#	if direction.dot(forward_velocity) > 0:
#		acceleration = DECELERATION
#
#	hv = hv.linear_interpolate(new_pos, acceleration * delta)
#	#velocity.x = hv.x
#	velocity.x = side_velocity.x
#	velocity.z = hv.z
#	velocity = move_and_slide(velocity, Vector3.UP)

func move_forward(delta):
	var forward_velocity = Vector3()
	if Input.is_action_pressed("move_forward"):
		forward_velocity += Vector3.FORWARD
	elif Input.is_action_pressed("move_stop"):
		forward_velocity = Vector3.BACK
	
	var fv = Vector3(0, 0, velocity.z)
	var new_pos = forward_velocity * F_SPEED
	var acceleration = DECELERATION
	if forward_velocity.dot(fv) > 0:
		acceleration = ACCELERATION
	
	fv = fv.linear_interpolate(new_pos, acceleration * delta)
	return fv

func move_sideways(delta):
	var sv = Vector3()
	if Input.is_action_pressed("move_left"):
		strafe_direction = strafe.left
	elif Input.is_action_pressed("move_right"):
		strafe_direction = strafe.right
		
	#sv = strafe_direction * S_SPEED
	#var new_pos = strafe_direction * S_SPEED
	if strafe_direction != strafe.idle:
		var s = 0
	var target_pos = transform.origin
	target_pos.x = strafe_direction.x * STRAFE_BOUNDARY
	var target_velocity = target_pos - transform.origin
	sv = clamp_vector(target_velocity * S_SPEED, S_SPEED)
	return sv

func clamp_vector(vector, length):
	var norm = vector.normalized()
	if vector.length() > length:
		vector = norm * length
	return vector