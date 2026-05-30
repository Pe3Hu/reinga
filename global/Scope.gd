extends Node


var is_pause: bool# = true
var phase: Bozo.Phase = Bozo.Phase.REPLENISHMENT
var phase_timer: Timer
var turn: int = 0
var layer: Bozo.Layer = Bozo.Layer.HELL


func next_phase(auto_: bool = true) -> void:
	if auto_:
		update_phase()
		phase_timer.start()

func update_phase() -> void:
	print([turn, Catalog.phase_to_string[phase]])
	phase = Catalog.phase_to_next[phase]
	if phase == Bozo.Phase.REPLENISHMENT:
		turn += 1
