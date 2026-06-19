extends Phase
class_name Payment


func get_type() -> Bozo.Phase:
	return Bozo.Phase.PAYMENT

func is_async() -> bool:
	return true

func enter() -> void:
	Cycle.hell.nightmare.abort_payment()
	Cycle.hell.nightmare.abort_guild()
	Cycle.hell.jail.sync_cage_sinners()
	Scope.weather = Bozo.Weather.MOON
	#Cycle.hell.weather_button.updaet_margin_offset()
	Cycle.hell.weather_button.apply_weather()
	#Cycle.hell.jail.apply_phase_visiblity()
	Cycle.hell.nightmare.awaken_dreams()

func exit() -> void:
	pass

#func enter() -> void:
	#var Cycle.hell := Cycle.Cycle.hell
	#Cycle.hell.jail.apply_phase_visiblity()
	#
	#for cage in Cycle.hell.jail.cages:
		#cage.sinner.apply_phase_visiblity()
	#
	#Cycle.hell.nightmare.awaken_dreams()
