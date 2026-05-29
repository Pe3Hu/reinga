class_name TributeData
extends Resource




func calc_half() -> void:
	var new_value = 0
	
	for token in trial.claim.sins:
		new_value += token.value
	
	
	progression.limit_value = floor(new_value*0.5)
