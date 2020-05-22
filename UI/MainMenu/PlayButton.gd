extends Button

func _ready():
	get_tree().paused = false


func _on_play_button_pressed():
	get_tree().change_scene("res://World/World.tscn")