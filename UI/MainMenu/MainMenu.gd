extends Control


func _ready():
	get_tree().paused = false


func _on_play_button_pressed():
	get_tree().change_scene("res://World/World.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_options_button_pressed():
	$OptionsMenu.visible = true
