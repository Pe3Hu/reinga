extends Node


var is_pause: bool = true
var phase: Bozo.Phase = Bozo.Phase.REPLENISHMENT
var phase_timer: Timer
var turn: int = 0
var layer: Bozo.Layer = Bozo.Layer.SANCTUARY


func next_phase(auto_: bool = true) -> void:
	if auto_:
		#print([turn, Catalog.phase_to_string[phase]])
		phase = Catalog.phase_to_next[phase]
		if phase == Bozo.Phase.REPLENISHMENT:
			turn += 1
		phase_timer.start()
