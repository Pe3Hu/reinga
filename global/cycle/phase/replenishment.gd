extends Phase
class_name Replenishment


func get_type() -> Bozo.Phase:
	return Bozo.Phase.REPLENISHMENT

func is_async() -> bool:
	return true

func enter() -> void:
	if Cycle.hell.world.abyss.data.counter == 0:
		Cycle.prepare_new_turn()
		Cycle._finish_current()
	else:
		Cycle.suspend(Bozo.Interrupt.ABYSS_SACRIFICE)
		Cycle.hell.world.transition.data.next_layer = Bozo.Layer.ABYSS
