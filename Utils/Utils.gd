extends Node

const default_puzzle_number = 5
var puzzle_number = default_puzzle_number


func clamp_vector(vector, length):
	var norm = vector.normalized()
	if vector.length() > length:
		vector = norm * length
	return vector


func number_hit_test(current_num):
	var award_points = true if current_num % puzzle_number == 0 else false
	return award_points