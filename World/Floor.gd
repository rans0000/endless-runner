extends RigidBody

var rng = RandomNumberGenerator.new()

var walls = [preload("res://World/Wall.tscn")]
export (Array, PackedScene) var trees

var MIN_WALL_DIST = 30
var MAX_WALL_DIST = 80
var board_length = 100
var MIN_TREES = 10
var MAX_TREES = 30
var MIN_TREE_POS = 5
var MAX_TREE_POS = 25

func _ready():
	rng.randomize()
	populate_with_walls()
	populate_with_trees()


func populate_with_walls():
	var pos = rng.randi_range(0, MIN_WALL_DIST)
	pos = pos - (board_length / 2)
	
	while pos < board_length:
		if pos <  - (board_length / 2):
			continue
		var wall_type = rng.randi_range(0, walls.size() - 1)
		var wall = walls[wall_type].instance()
		add_child(wall)
		wall.transform.origin = Vector3(0, 0, pos)
		pos = rng.randi_range(pos + MIN_WALL_DIST, pos + MAX_WALL_DIST)


func populate_with_trees():
	var total_trees = rng.randi_range(MIN_TREES, MAX_TREES)
	for i in range(total_trees):
		var pos_x = rng.randi_range(MIN_TREE_POS, MAX_TREE_POS) * ( -1 if (i % 2 == 0) else 1 )
		var pos_z = rng.randi_range(0, board_length)
		var tree_type = rng.randi_range(0, trees.size() - 1)
		var the_tree = trees[tree_type].instance()
		add_child(the_tree)
		the_tree.transform.origin = Vector3(pos_x, 0, pos_z)
	pass