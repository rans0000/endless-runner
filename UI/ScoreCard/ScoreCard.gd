extends Control

export var player = "P1"
onready var distance_score = $PointsWrap/Rc/DistanceScore
onready var coin_score = $PointsWrap/Rc/CoinScore
onready var boost_score = $PointsWrap/Rc/BoostIcon
onready var puzzle_number = $FactorWrap/FactoreScore

func _ready():
	distance_score.set_distance(0)
	coin_score.clear_coins()
	boost_score.clear_boosts()
	pass


func set_distance(val):
	distance_score.set_distance(val)


func add_coins(val=1):
	coin_score.add_coins(val)


func set_sprint():
	boost_score.set_sprint()


func clear_boosts():
	boost_score.clear_boosts()


func set_puzzle_number():
	puzzle_number.set_puzzle_number()