class_name SinState
extends RefCounted

var available: int = 0
var trial_to_weight: Dictionary = {}

func get_demand() -> int:
	var sum := 0
	for t in trial_to_weight:
		sum += trial_to_weight[t]
	return sum

func is_finished() -> bool:
	return available == 0 or trial_to_weight.is_empty()

func get_weight() -> int:
	return min(available, get_demand())
