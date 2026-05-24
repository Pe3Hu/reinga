class_name DreamData
extends Resource


@export var sinner: SinnerData

var primary_desire: Bozo.Desire
var secondary_desire: Bozo.Desire


func _init(sinner_: SinnerData) -> void:
	sinner = sinner_
	
	init_desires()

func init_desires() -> void:
	var trial = Helper.get_random_key(Catalog.faction_to_trial[sinner.faction])
	primary_desire = Catalog.trial_to_disere[trial]
	var desire_options = []
	desire_options.append_array(Catalog.desires)
	desire_options.erase(primary_desire)
	desire_options.shuffle()
	secondary_desire = desire_options.pick_random()
