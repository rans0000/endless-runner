extends StaticBody

onready var segments = [preload("res://World/Numbers/Num_0.tscn"),preload("res://World/Numbers/Num_1.tscn"),preload("res://World/Numbers/Num_2.tscn"),preload("res://World/Numbers/Num_3.tscn"),preload("res://World/Numbers/Num_4.tscn"),preload("res://World/Numbers/Num_5.tscn"),preload("res://World/Numbers/Num_6.tscn"),preload("res://World/Numbers/Num_7.tscn"),preload("res://World/Numbers/Num_8.tscn"),preload("res://World/Numbers/Num_9.tscn")]

var rng = RandomNumberGenerator.new()
const SEGMENT_WIDTH = 1.2
const SEGMENT_HALF_WIDTH = SEGMENT_WIDTH / 2
const puzzle_number = 5
const act_multiply = "multiply"
const act_division = "division"
var action = act_multiply
const MAX_NUMBER = 100
var current_num = 0;

func _ready():
	rng.randomize()
	current_num = rng.randi_range(0, MAX_NUMBER)
	build_number_mesh(current_num)


func build_number_mesh(current_num):
	var num_string = str(current_num)	
	var count = num_string.length()
	var iterator = 0
	var total_width = SEGMENT_WIDTH * count
	var pos_x = (total_width / 2) - ((SEGMENT_WIDTH * count) - SEGMENT_HALF_WIDTH)
	
	for digit in num_string:
		var num_mesh = segments[int(digit)].instance()
		add_child(num_mesh)
		#print(num_string, " - ", pos_x)
		num_mesh.transform.origin = Vector3(pos_x, 0, 0)
		pos_x = pos_x + SEGMENT_WIDTH
		iterator += 1