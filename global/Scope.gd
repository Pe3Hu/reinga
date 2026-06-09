extends Node


@warning_ignore("unused_signal")
signal layer_changed

var is_pause: bool# = true
var phase: Bozo.Phase = Bozo.Phase.ENDOWMENT
var phase_timer: Timer
var turn: int = 0
var layer: Bozo.Layer = Bozo.Layer.NONE:
	set(value_):
		layer = value_
		emit_signal("layer_changed")

var guild_level: int = 1

#region plaza
var trust_limit: int = 2
var hope_limit: int = 5

var attitude_shift: int = 1
var amber_shift: int = 5
var flame_shift: int = 6
#endregion


func next_phase(auto_: bool = true) -> void:
	if auto_:
		update_phase()
		phase_timer.start()

func update_phase() -> void:
	#print([turn, Catalog.phase_to_string[phase]])
	phase = Catalog.phase_to_next[phase]
	if phase == Bozo.Phase.REPLENISHMENT:
		turn += 1
