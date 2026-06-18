extends Phase
class_name Replenishment


func get_type() -> Bozo.Phase:
	return Bozo.Phase.REPLENISHMENT


func enter() -> void:
	var hell := Cycle.hell
	hell.world.data.tribunal.refill_actual()
	hell.jail.update_sinner_datas()
