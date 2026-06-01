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
	
	if total <= 0:
		return null
	
	var r := rng.randf() * total
	var cumulative := 0.0
	
	for key in keys:
		cumulative += dict_[key]
		if r < cumulative:
			return key
	
	push_error("random selection failed")
	return null


#var example_weights = {
	#"miss": 3,
	#"crit": 5,
	#"megacrit": 1,
	#"normal": 92
#}
#
#var subtype_to_count = {
	#"example 1": 10,
	#"example 2": 15,
	#"example 3": 20
#}
#
#func simulate_per_subtype(subtype_to_count: Dictionary, weights: Dictionary) -> Dictionary:
	#var result = {}
	#
	#for subtype in subtype_to_count:
		#var count = subtype_to_count[subtype]
		#
		#var local = {
			#"miss": 0,
			#"normal": 0,
			#"crit": 0,
			#"megacrit": 0
		#}
		#
		#for i in count:
			#var roll = get_random_key(weights)
			#local[roll] += 1
		#
		#result[subtype] = local
	#
	#return result
