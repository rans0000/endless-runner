extends Control

var is_paused = false

func _ready():
	self.visible = false


func _process(delta):
	if Input.is_action_just_pressed("pause_game"):
		toggle_pause()


func _on_resumebutton_pressed():
	toggle_pause()


func toggle_pause():
	is_paused = !is_paused
	visible = is_paused
	get_tree().paused = is_paused


func _on_mainmenu_button_pressed():
	get_tree().change_scene("res://UI/MainMenu/MainMenu.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
