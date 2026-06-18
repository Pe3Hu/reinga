extends Phase
class_name Payment


func get_type() -> Bozo.Phase:
	return Bozo.Phase.PAYMENT


func is_async() -> bool:
	return true


func enter() -> void:
	var hell := Cycle.hell
	hell.jail.apply_phase_visiblity()
	
	for cage in hell.jail.cages:
		cage.sinner.apply_phase_visiblity()
	
	hell.nightmare.awaken_dreams()
