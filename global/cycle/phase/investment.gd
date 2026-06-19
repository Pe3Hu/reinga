extends Phase
class_name Investment


func get_type() -> Bozo.Phase:
	return Bozo.Phase.INVESTMENT

func is_async() -> bool:
	return true

func enter() -> void:
	Cycle.hell.weather_button.switch_weather()
	Cycle.hell.reset()
	Cycle.hell.world.data.tribunal.actual.clear()
	Cycle.hell.nightmare.apply_attitude_privileges()
