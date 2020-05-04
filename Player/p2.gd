extends KinematicBody

var gravity = -9.8
var velocity = Vector3()

const SPEED = 6
const ACCELERATION = 3
const DE_ACCELERATION = 5

func _physics_process(delta):
	var dir = Vector3()

	if(Input.is_action_pressed("move_forward")):
		dir += -transform.basis[2]

	if(Input.is_action_pressed("move_stop")):
		dir += transform.basis[2]

	if(Input.is_action_pressed("move_left")):
		dir += -transform.basis[0]

	if(Input.is_action_pressed("move_right")):
		dir += transform.basis[0]

	dir.y = 0
	dir = dir.normalized()
	velocity.y += delta * gravity

	var hv = velocity
	hv.y = 0

	var new_pos = dir * SPEED
	var accel = DE_ACCELERATION

	if (dir.dot(hv) > 0):
		accel = ACCELERATION

	hv = hv.linear_interpolate(new_pos, accel * delta)
	velocity.x = hv.x
	velocity.z = hv.z

	velocity = move_and_slide(velocity, Vector3(0,1,0))	