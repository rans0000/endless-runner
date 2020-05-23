extends Camera

func _input(event):
	if event.is_action_pressed("look_back"):
		rotate_y(deg2rad(180))
	elif event.is_action_released("look_back"):
		rotate_y(deg2rad(180))