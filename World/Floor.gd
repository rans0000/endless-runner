extends RigidBody

var rng = RandomNumberGenerator.new()

var wall_list = [preload("res://World/Wall.tscn")]

var MIN_WALL_DIST = 30
var MAX_WALL_DIST = 80
var board_length = 100

func _ready():
	rng.randomize()
	populate_with_walls()


func populate_with_walls():
	var wall_size = wall_list.size()
	var pos = rng.randi_range(0, MIN_WALL_DIST)
	pos = pos - (board_length / 2)
	#print("Post: ", pos)
	
	while pos < board_length:
		if pos <  - (board_length / 2):
			continue
		var wall_type = rng.randi_range(0, wall_size - 1)
		var wall = wall_list[wall_type].instance()
		add_child(wall)
		wall.transform.origin = Vector3(0, 0, pos)
		pos = rng.randi_range(pos + MIN_WALL_DIST, pos + MAX_WALL_DIST)