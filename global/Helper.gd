extends Node


var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()


func get_random_key(dict_: Dictionary):
	if dict_.is_empty():
		push_error("empty dictionary in get_random_key")
		return null
	
	var keys = dict_.keys()
	var total := 0.0
	
	for key in keys:
		total += dict_[key]
	
	var r := rng.randf() * total
	var cumulative := 0.0
	
	for key in keys:
		cumulative += dict_[key]
		if r < cumulative:
			return key
	
	push_error("random selection failed")
	return null
