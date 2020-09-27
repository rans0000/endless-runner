extends Spatial

onready var label = $Viewport/Control/Label

func set_number(number):
	label.text = String(number)