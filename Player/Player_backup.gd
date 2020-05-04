extends KinematicBody

var gravity = -9.8
var velocity = Vector3()

const SPEED = 40
const ACCELERATION = 3
const DECELERATION = 5

func _physics_process(delta):
	move_player(delta)

func move_player(delta):
	var direction = Vector3()
	
	if Input.is_action_pressed("move_forward"):
		direction += -transform.basis.z
	elif Input.is_action_pressed("move_stop"):
		direction = transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction += -transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	direction.y = 0
	direction = direction.normalized()
	velocity.y += delta * gravity
	
	var hv = velocity
	hv.y = 0
	
	var new_pos = direction * SPEED
	var acceleration = DECELERATION
	
	if direction.dot(hv) > 0:
		acceleration = ACCELERATION
	
	hv = hv.linear_interpolate(new_pos, acceleration * delta)
	velocity.x = hv.x
	velocity.z = hv.z
	
	velocity = move_and_slide(velocity, Vector3.UP)
	print(velocity)