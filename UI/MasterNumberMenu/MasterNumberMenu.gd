extends Control

onready var value_label = $MasterValueLabel;
onready var slider = $HSlider;

func _ready():
	value_label.text = str(slider.value)


func _on_master_value_slider_changed(value):
	value_label.text = str(value)


func _on_select_btn_up():
	print('_on_select_btn_up')


func _on_cancel_btn_up():
	print('_on_cancel_btn_up')