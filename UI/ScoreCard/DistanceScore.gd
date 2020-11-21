extends Control


onready var distance = $Panel/MarginContainer/Label


func _ready():
	distance.text=""


func set_distance(val):
	distance.text = val as String + "m"