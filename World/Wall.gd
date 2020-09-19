extends StaticBody

onready var obstacle = preload("res://World/Obstacles/ObstacleNumber.tscn")

var rng = RandomNumberGenerator.new()
const SEGMENT_WIDTH = 5
const MAX_SEGMENTS = 3
const SEGMENT_HALF_WIDTH = SEGMENT_WIDTH / 2

func _ready():
	build_wall_segments()


func build_wall_segments():
	rng.randomize()
	var pos_x = rng.randi_range(-1, 1) * SEGMENT_HALF_WIDTH
	var segment = obstacle.instance()
	add_child(segment)
	segment.transform.origin = Vector3(pos_x, 0, 0)