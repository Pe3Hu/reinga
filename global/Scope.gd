extends Node


@warning_ignore("unused_signal")
signal layer_changed


var sanctuary: SanctuaryData

var is_game: bool = false
var is_skip: bool = false

var phase: Bozo.Phase = Bozo.Phase.ENDOWMENT
var turn: int = 0
var essence: int = 0

var layer: Bozo.Layer = Bozo.Layer.MENU:
	set(value_):
		layer = value_
		emit_signal("layer_changed")

var weather: Bozo.Weather = Bozo.Weather.MOON
var exodus: Bozo.Exodus = Bozo.Exodus.NONE:
	set(value_):
		exodus = value_
		apply_exodus()

#region plaza
#var trust_limit: int = 2
#var hope_limit: int = 5

#var amber_shift: int = 5
#var attitude_shift: int = 1
#var flame_shift: int = 6

var spectacle_to_factor = {
	Bozo.Spectacle.BALLET: 0,
	Bozo.Spectacle.PUPPETRY: 0,
	Bozo.Spectacle.OPERA: 0,
}

var posture_to_factor = {
	Bozo.Posture.MADNESS: 0,
	Bozo.Posture.OBLIVION: 0,
}

var guild_level: int = 1
#endregion

func switch_weather() -> void:
	Scope.weather = Catalog.weather_to_next[Scope.weather]

func reset() -> void:
	spectacle_to_factor = {
		Bozo.Spectacle.BALLET: 0,
		Bozo.Spectacle.PUPPETRY: 0,
		Bozo.Spectacle.OPERA: 0,
	}
	
	posture_to_factor = {
		Bozo.Posture.MADNESS: 0,
		Bozo.Posture.OBLIVION: 0,
	}
	
	turn = 0
	essence = 0
	phase = Bozo.Phase.ENDOWMENT
	layer = Bozo.Layer.MENU
	weather = Bozo.Weather.MOON
	exodus = Bozo.Exodus.NONE
	guild_level = 1

func equalize_posture_factors() -> void:
	var rank_shift = min(posture_to_factor[Bozo.Posture.MADNESS], posture_to_factor[Bozo.Posture.OBLIVION])
	
	if rank_shift > 0:
		for posture in posture_to_factor:
			posture_to_factor[posture] -= rank_shift
		
		sanctuary.world.throne.marvone.rank += rank_shift

func apply_exodus() -> void:
	if exodus == 0: return
	Cycle.stop()
	sanctuary.world.transition.next_layer = Bozo.Layer.EXODUS
