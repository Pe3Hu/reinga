extends Phase
class_name Appraisement


func get_type() -> Bozo.Phase:
	return Bozo.Phase.APPRAISEMENT

func is_async() -> bool:
	return true

func enter() -> void:
	Scope.weather = Bozo.Weather.SUN
	#Cycle.hell.weather_button.updaet_margin_offset()
	Cycle.hell.weather_button.apply_weather()
	#Cycle.hell.jail.apply_phase_visiblity()
	Cycle.hell.treasury.appraisement_preparation()
	Cycle.hell.jail.dissolve_guilds()
	Cycle.hell.volcano.flow_plaza_update()
	Cycle.hell.simulate_choice()
