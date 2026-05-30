class_name DreamData
extends Resource


@export var sinner: SinnerData

var primary: DesireData
var secondary: DesireData

signal primary_desire_changed
signal secondary_desire_changed

var primary_desire: Bozo.Desire:
	set(value_):
		primary_desire = value_
		if primary:
			primary.type = value_
		emit_signal("primary_desire_changed")
var secondary_desire: Bozo.Desire:
	set(value_):
		secondary_desire = value_
		if secondary:
			secondary.type = value_
		emit_signal("secondary_desire_changed")


func _init(sinner_: SinnerData) -> void:
	sinner = sinner_
	
	init_desires()

func init_desires() -> void:
	var trial = Helper.get_random_key(Catalog.faction_to_trial[sinner.fate.faction.type])
	primary = DesireData.new(Catalog.trial_to_desire[trial])
	primary_desire = primary.type
	var desire_options = []
	desire_options.append_array(Catalog.desires)
	desire_options.erase(primary_desire)
	desire_options.shuffle()
	secondary = DesireData.new(desire_options.pick_random())
	secondary_desire = secondary.type

func update_desires(desires_: Dictionary) -> void:
	if !desires_.has(primary_desire):
		desires_[primary_desire] = 0
	
	desires_[primary_desire] += Catalog.PRIMARY_DESIRE_COUNT
	
	if !desires_.has(secondary_desire):
		desires_[secondary_desire] = 0
	
	desires_[secondary_desire] += Catalog.SECONDARY_DESIRE_COUNT
