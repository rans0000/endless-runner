extends Spatial

const master_floor = preload("res://World/Floor.tscn")

const BOARD_SET_LENGTH = 3
var boards = []
var board_length = 100

func _ready():
	var start_floor = $StartFloor
	boards.push_back(start_floor)
	$Player.connect("detect_empty_floor", self, "create_floor")
	$Player.connect("detect_obsolete_floor", self, "delete_floor")

func create_floor():
	var last_floor = boards[-1].global_transform.origin
	
	for i in BOARD_SET_LENGTH:
		var floor_instance = master_floor.instance()
		add_child(floor_instance)
		var pos_z = -board_length * (i + 1)
		floor_instance.global_transform.origin = last_floor + Vector3(0, 0, pos_z)
		boards.push_back(floor_instance)
	print(boards.size())

func delete_floor(target_floor):
	#print('deleting...', target_floor)
	boards.erase(target_floor)
	target_floor.queue_free()