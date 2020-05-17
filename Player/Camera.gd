extends Camera

func _input(event):
	if event.is_action_pressed("ui_down"):
		rotate_y(deg2rad(180))
	elif event.is_action_released("ui_down"):
		rotate_y(deg2rad(180))