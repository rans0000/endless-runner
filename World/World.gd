extends Spatial

const master_floor = preload("res://World/Floor/Floor.tscn")

onready var number_menu = $MasterNumberMenu
onready var bg_music = $BGMusic
var target_pitch = 1

const BOARD_SET_LENGTH = 3
var boards = []
var board_length = 100

func _process(delta):
	bg_music.pitch_scale = lerp(bg_music.pitch_scale, target_pitch, delta)

func _ready():
	var start_floor = $StartFloor
	boards.push_back(start_floor)
	$Player.connect("detect_empty_floor", self, "create_floor")
	$Player.connect("detect_obsolete_floor", self, "delete_floor")
	$Player.connect("boost_mode", self, "adjust_bg_music")
	get_tree().paused = true
	number_menu.visible = true


func create_floor():
	var last_floor = boards[-1].global_transform.origin
	
	for i in BOARD_SET_LENGTH:
		var floor_instance = master_floor.instance()
		add_child(floor_instance)
		var pos_z = -board_length * (i + 1)
		floor_instance.global_transform.origin = last_floor + Vector3(0, 0, pos_z)
		boards.push_back(floor_instance)
	#print(boards.size())


func delete_floor(target_floor):
	#print('deleting...', target_floor)
	boards.erase(target_floor)
	target_floor.queue_free()


func adjust_bg_music(type):
	if type == 1:
		target_pitch = 1.2
	elif type == -1:
		target_pitch = 0.9
	else:
		target_pitch = 1


