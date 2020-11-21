extends Control


onready var	boosts = $Bg.get_children()


func _ready():
	clear_boosts()
	pass


func clear_boosts():
	for boost in boosts:
		boost.visible = false


func set_sprint():
	clear_boosts()
	$Bg/SprintIcon.visible = true