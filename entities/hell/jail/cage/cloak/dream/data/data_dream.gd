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
	primary_desire = Catalog.trial_to_desire[trial]
	var desire_options = []
	desire_options.append_array(Catalog.desires)
	desire_options.erase(primary_desire)
	desire_options.shuffle()
	secondary_desire = desire_options.pick_random()

func update_desires(desires_: Dictionary) -> void:
	if !desires_.has(primary_desire):
		desires_[primary_desire] = 0
	
	desires_[primary_desire] += Catalog.PRIMARY_DESIRE_COUNT
	
	if !desires_.has(secondary_desire):
		desires_[secondary_desire] = 0
	
	desires_[secondary_desire] += Catalog.SECONDARY_DESIRE_COUNT
