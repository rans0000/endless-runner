extends RigidBody

var rng = RandomNumberGenerator.new()

var walls = [preload("res://World/Wall.tscn")]
export (Array, PackedScene) var houses
export (Array, PackedScene) var trees
export (PackedScene) var street_scene

var board_length = 100
var MIN_WALL_DIST = 10
var MAX_WALL_DIST = 30
var MIN_TREES = 10
var MAX_TREES = 30
var MIN_TREE_POS = 5
var MAX_TREE_POS = 25
var HOME_SPAWN_CHANCE = 50
var HOME_WIDTH = 20
var HOME_LENGTH = 30
var street_x_offset = 53.3

func _ready():
	rng.randomize()
	populate_environment()


func populate_environment():
	#var has_home = populate_with_homes()
	#populate_with_trees(has_home)
	populate_street()
	pass


func populate_street():
	var street = street_scene.instance()
	street.transform.origin = Vector3(street_x_offset, 0, 0)
	add_child(street)
	street = street_scene.instance()
	street.transform.origin = Vector3(-street_x_offset, 0, 0)
	add_child(street)
	pass


func populate_with_walls():
	var pos = rng.randi_range(0, MIN_WALL_DIST)
	#pos = pos - (board_length / 2)
	
	while pos < board_length:
		if pos <  - (board_length / 2):
			continue
		var wall_type = rng.randi_range(0, walls.size() - 1)
		var wall = walls[wall_type].instance()
		add_child(wall)
		wall.transform.origin = Vector3(0, 0, pos)
		pos = rng.randi_range(pos + MIN_WALL_DIST, pos + MAX_WALL_DIST)


func populate_with_homes():
	var has_home = rng.randi_range(0,100) < HOME_SPAWN_CHANCE
	if has_home:
		var house_type = rng.randi_range(0, houses.size()-1)
		var home = houses[house_type].instance()
		add_child(home)
		var side = ( -1 if (rng.randi_range(0,1) == 0) else 1 )
		var pos_x = (MIN_TREE_POS + (HOME_LENGTH / 2)) * side
		home.transform.origin = Vector3(pos_x, 0, board_length/2)
		if side == -1:
			home.rotate_y(deg2rad(180))
	return has_home


func populate_with_trees(has_home = false):
	var total_trees = rng.randi_range(MIN_TREES, MAX_TREES)
	for i in range(total_trees):
		var pos_x = rng.randi_range(MIN_TREE_POS, MAX_TREE_POS) * ( -1 if (i % 2 == 0) else 1 )
		
		var upper_bound = ((board_length/2)-(HOME_WIDTH/2)) if has_home else (board_length)
		var pos_z = rng.randi_range(0, board_length)
		pos_z = ((pos_z+(board_length/2)) * (-1 if (i%2 == 0) else 1)) if has_home else pos_z
		
		var tree_type = rng.randi_range(0, trees.size() - 1)
		var the_tree = trees[tree_type].instance()
		add_child(the_tree)
		the_tree.transform.origin = Vector3(pos_x, 0, pos_z)
		the_tree.rotate_y(deg2rad(rng.randi_range(0,360)))


func _on_number_feeler_entered(body):
#	print(self, " : ", body.name)
	populate_with_walls()
