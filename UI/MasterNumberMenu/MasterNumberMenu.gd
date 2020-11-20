extends Control

onready var Utils = get_node("/root/Utils")

func _ready():
	pass


func _on_cancel_btn_up():
	self.visible = false
	get_tree().paused = false


func _on_master_value_click(selected_value):
	print(selected_value)
	Utils.puzzle_number = selected_value
	self.visible = false
	get_tree().paused = false