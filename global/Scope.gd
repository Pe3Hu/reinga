extends Node


var is_pause: bool = false
var in_progress: bool = false
var phase: Bozo.Phase = Bozo.Phase.REPLENISHMENT



func next_phase(auto_: bool = true) -> void:
	if auto_:
		print(Catalog.phase_to_string[phase])
		phase = Catalog.phase_to_next[phase]
