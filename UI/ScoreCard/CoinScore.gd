extends Control


onready var coins = $MarginContainer/Panel/MarginContainer/Label
var total = 0


func _ready():
	clear_coins()


func add_coins(val=1):
	total += val
	coins.text = total as String


func clear_coins(val=1):
	total = 0
	coins.text = total as String