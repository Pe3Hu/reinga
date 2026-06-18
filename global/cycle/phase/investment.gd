extends Phase
class_name Investment


func get_type() -> Bozo.Phase:
	return Bozo.Phase.INVESTMENT


func is_async() -> bool:
	return true


func enter() -> void:
	var hell := Cycle.hell
	hell.weather_button.switch_weather()
	hell.reset()
	hell.world.data.tribunal.actual.clear()
	
	if hell.world.data.tribunal.is_enough():
		Cycle.complete_phase()
	else:
		Cycle.suspend(Bozo.Interrupt.GATE_RECRUIT)
		hell.world.data.transition.next_layer = Bozo.Layer.GATE
