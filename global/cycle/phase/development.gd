extends Phase
class_name Development


func get_type() -> Bozo.Phase:
	return Bozo.Phase.DEVELOPMENT

func is_async() -> bool:
	return true

func enter() -> void:
	Cycle.hell.market.data.refill_closed_deals()
	Cycle.hell.nightmare.start_drain_tributes()
