extends Phase
class_name Development


func get_type() -> Bozo.Phase:
	return Bozo.Phase.DEVELOPMENT


func is_async() -> bool:
	return true


func enter() -> void:
	var hell := Cycle.hell
	hell.market.data.refill_closed_deals()
	hell.nightmare.start_drain_tributes()
