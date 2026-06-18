extends Phase
class_name Appraisement


func get_type() -> Bozo.Phase:
	return Bozo.Phase.APPRAISEMENT


func is_async() -> bool:
	return true


func enter() -> void:
	var hell := Cycle.hell
	hell.treasury.appraisement_preparation()
	hell.jail.dissolve_guilds()
	hell.volcano.flow_plaza_update()
