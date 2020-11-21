extends Control

onready var Utils = get_node("/root/Utils")
onready var factor = $Label


func _ready():
	factor.text=""


func set_puzzle_number():
	factor.text = Utils.puzzle_number as String