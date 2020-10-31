extends Control

onready var Utils = get_node("/root/Utils")
onready var value_label = $MasterValueLabel;
onready var slider = $HSlider;

func _ready():
	slider.value = Utils.puzzle_number
	value_label.text = str(slider.value)


func _on_master_value_slider_changed(value):
	value_label.text = str(value)


func _on_select_btn_up():
	Utils.puzzle_number = int(slider.value)
	self.visible = false
	get_tree().paused = false


func _on_cancel_btn_up():
	self.visible = false
	get_tree().paused = false