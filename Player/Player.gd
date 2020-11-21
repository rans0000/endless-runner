extends KinematicBody

signal detect_empty_floor
signal detect_obsolete_floor

onready var Utils = get_node("/root/Utils")
onready var animationTree = $PlayerModel/AnimationTree
onready var playback = animationTree.get('parameters/playback')
onready var forward_timer = $ForwardSpeedTimer
onready var score_card = $ScoreCard

var gravity = -9.3 * 8
var velocity = Vector3()
var previous_speed = Vector3()
var strafe_position = [-1, 0, 1]
var current_strafe_position = 1
const MAX_STRAFE_POSITION = 3

var state = { idle='Idle', jump_start='Jump_Start', jump_end='Jump_End', move='Move' }
var curr_state = state.idle
var forward_speed = 30
const REGULAR_FORWARD_SPEED = 30
const FORWARD_BONUS_SPEED = 50
const FORWARD_PENALTY_SPEED = 10
const STRAFE_DISTANCE = 2.5
const STRAFE_SPEED = 20
const ACCELERATION = 1
const DECELERATION = 3
const FRICTION = 0.1

const CLIMB_SPEED = 10

var is_jumping = false
var is_powering_jump = false
var jump_power = 0
const MIN_JUMP_SPEED = 12
const MAX_JUMP_FORWARD_RATIO = 0.3
const MAX_JUMP_POWER = 2

onready var front_feeler = $FrontFeeler
onready var back_feeler = $BackFeeler


func _ready():
	playback.start(state.idle)


func _process(delta):
	score_card.set_distance(-transform.origin.z as int)


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
	check_floor()

func move_forward(delta):
	var is_floored = is_on_floor()
	var forward_velocity = Vector3()
	
#	if is_floored and Input.is_action_pressed("move_forward"):
#		forward_velocity += Vector3.FORWARD
#	elif is_floored and Input.is_action_pressed("move_stop"):
#		forward_velocity = Vector3.BACK
	
	var fv = Utils.clamp_vector(Vector3(0, 0, velocity.z), forward_speed)
	if is_floored:
		forward_velocity += Vector3.FORWARD
		var new_pos = forward_velocity * forward_speed
		previous_speed = new_pos
		var acceleration = DECELERATION
		if forward_velocity.dot(fv) > 0:
			acceleration = ACCELERATION
		
		fv = fv.linear_interpolate(new_pos, acceleration * delta)
		set_run_animation(fv)
	return fv


func set_run_animation(forward_velocity):
	var speed = forward_velocity.length()
	
	if(speed > 0.5 and speed < forward_speed + 0.5):
		if curr_state != state.move:
			curr_state = state.move
			playback.travel(curr_state)
		var run_speed = speed / forward_speed
		animationTree.set('parameters/Move/blend_position', run_speed)
	elif speed < 0.5:
		if curr_state != state.idle:
			curr_state = state.idle
			playback.travel(curr_state)


func move_sideways():
	var is_floored = is_on_floor()
	var slide_velocity = Vector3()
	
	if is_floored and Input.is_action_just_pressed("move_left"):
		current_strafe_position = (0) if (current_strafe_position - 1 < 0) else (current_strafe_position - 1)
	elif is_floored and Input.is_action_just_pressed("move_right"):
		current_strafe_position = (MAX_STRAFE_POSITION -1 ) if (current_strafe_position + 1 >= MAX_STRAFE_POSITION) else (current_strafe_position + 1)
	
	var target_pos = transform.origin
	target_pos.x = strafe_position[current_strafe_position] * STRAFE_DISTANCE
	var target_velocity = target_pos - transform.origin
	slide_velocity = Utils.clamp_vector(target_velocity * STRAFE_SPEED, STRAFE_SPEED)
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
	
	if not is_jumping and Input.is_action_just_pressed("jump"):
		is_powering_jump = true
	if not is_jumping and Input.is_action_just_released("jump"):
		is_powering_jump = false
		is_jumping = true
		jump_speed.y += calculate_jump_power(jump_speed)
		set_jump_animation()
	return jump_speed


func calculate_jump_power(jump_speed):
	var vertical_speed = jump_speed.y
	var speed_ratio = (jump_power/MAX_JUMP_POWER * MAX_JUMP_FORWARD_RATIO) * -velocity.z
	var power = (MIN_JUMP_SPEED + speed_ratio )
	vertical_speed += power
	return vertical_speed


func set_jump_animation():
	if curr_state != state.jump_start:
		curr_state = state.jump_start
		playback.travel(curr_state)


func check_floor():
	if !front_feeler.is_colliding():
		emit_signal("detect_empty_floor")
	if back_feeler.is_colliding():
		var target = back_feeler.get_collider()
		if target.is_in_group("Floor"):
			emit_signal("detect_obsolete_floor", target)


func on_collide_number(award_points):
	if award_points:
		forward_timer.start()
		forward_speed = FORWARD_BONUS_SPEED
		velocity = velocity + (velocity * .5)
		score_card.add_coins()
		score_card.set_sprint()
	else:
		forward_speed = FORWARD_PENALTY_SPEED
		velocity = velocity / 2
		score_card.clear_boosts()

func _on_forward_timer_timeout():
	forward_speed = REGULAR_FORWARD_SPEED
	score_card.clear_boosts()


func _on_master_number_timeout():
	score_card.set_puzzle_number()
