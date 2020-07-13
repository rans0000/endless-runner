extends StaticBody

onready var segments = [preload("res://World/Obstacles/ObstacleSmall.tscn"), preload("res://World/Obstacles/ObstacleMedium.tscn"), preload("res://World/Obstacles/ObstacleHigh.tscn")]

var rng = RandomNumberGenerator.new()
const SEGMENT_WIDTH = 2.5

func _ready():
	build_wall_segments()


func build_wall_segments():
	rng.randomize()
	var segment_size = segments.size()
	for pos in range(-1, 2):
		var seg_pos_x = pos * SEGMENT_WIDTH
		var segment = segments[rng.randi_range(0, segment_size - 1)].instance()
		add_child(segment)
		segment.transform.origin = Vector3(seg_pos_x, 0, 0)