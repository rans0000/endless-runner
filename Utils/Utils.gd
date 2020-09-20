extends Node

var puzzle_number = 5
var act_multiply = "multiply"
var act_division = "division"
var action = act_division


func clamp_vector(vector, length):
	var norm = vector.normalized()
	if vector.length() > length:
		vector = norm * length
	return vector


func number_hit_test(current_num):
	var award_points = false
	match action:
		act_division: 
			award_points = true if current_num % puzzle_number == 0 else false
		act_multiply: 
			award_points = true if puzzle_number % current_num == 0  else false
	return award_points