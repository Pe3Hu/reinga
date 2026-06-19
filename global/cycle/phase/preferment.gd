extends Phase
class_name Preferment


func get_type() -> Bozo.Phase:
	return Bozo.Phase.INVESTMENT

func is_async() -> bool:
	return true

func enter() -> void:
	if Cycle.hell.world.data.tribunal.is_enough():
		Cycle.complete_phase()
	else:
		Cycle.suspend(Bozo.Interrupt.GATE_RECRUIT)
		Cycle.hell.world.data.transition.next_layer = Bozo.Layer.GATE
