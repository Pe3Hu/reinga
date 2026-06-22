class_name DreamData
extends Resource


signal desire_changed

@export var sinner: SinnerData

var desires: Array[DesireData]

var primary_desire: Bozo.Desire:
	set(value_):
		primary_desire = value_
		emit_signal("desire_changed")
var secondary_desire: Bozo.Desire:
	set(value_):
		secondary_desire = value_
		emit_signal("desire_changed")
var madness_desire: Bozo.Desire

var type_to_count: Dictionary


#region init
func _init(sinner_: SinnerData) -> void:
	sinner = sinner_
	
	init_desires()

func init_desires() -> void:
	var trial = Helper.get_random_key(Catalog.faction_to_trial[sinner.fate.faction.type])
	
	var primary_data = DesireData.new(Catalog.trial_to_desire[trial])
	primary_desire = primary_data.type
	desires.append(primary_data)
	
	primary_data = DesireData.new(Catalog.trial_to_desire[trial])
	desires.append(primary_data)
	
	var desire_options = []
	desire_options.append_array(Catalog.desires)
	desire_options.erase(primary_desire)
	desire_options.shuffle()
	secondary_desire = desire_options.pick_random()
	var secondary_data = DesireData.new(secondary_desire)
	desires.append(secondary_data)
	
	for desire in desires:
		desire.dream = self
		
		if !type_to_count.has(desire.type):
			type_to_count[desire.type] = 0
		
		type_to_count[desire.type] += 1
#endregion

func update_desires(desires_: Dictionary) -> void:
	for desire in desires:
		if desire.value != 0:
			if !desires_.has(desire.type):
				desires_[desire.type] = 0
			
			desires_[desire.type] += desire.value

func apply_guild(is_guild_: bool = true) -> void:
	for index in Catalog.guild_level_to_index[Scope.guild_level]:
		var desire = desires[index]
		
		if is_guild_:
			desire.association = Bozo.Association.GUILD
		else:
			desire.association = Bozo.Association.NONE

func reset_associations() -> void:
	for desire in desires:
		desire.association = Bozo.Association.NONE

func fuse_desire(desire_: DesireData) -> void:
	desire_.dream = self
	var is_primary = primary_desire == desire_.type
	
	if is_primary:
		sinner.dream.desires.push_front(desire_)
	else:
		sinner.dream.desires.push_back(desire_)
	
	type_to_count[desire_.type] += 1

func on_overlord_duty(overlord_: OverlordData) -> bool:
	var desire_trials = [
		Catalog.desire_to_trial[primary_desire],
		Catalog.desire_to_trial[secondary_desire]
	]
	
	var overlord_trial = Catalog.overlord_to_trial[overlord_.type]
	return desire_trials.has(overlord_trial)

func get_not_overlord_desire(overlord_: OverlordData) -> Bozo.Desire:
	if !on_overlord_duty(overlord_): return Bozo.Desire.NONE
	
	var desire_trials = [
		Catalog.desire_to_trial[primary_desire],
		Catalog.desire_to_trial[secondary_desire]
	]
	
	var overlord_trial = Catalog.overlord_to_trial[overlord_.type]
	desire_trials.erase(overlord_trial)
	return desire_trials.back()

func add_madness_desire() -> DesireData:
	var max_count = 10
	var options: Array[Bozo.Desire]
	
	for desire in type_to_count:
		if type_to_count[desire] == max_count:
			options.append(desire)
		if type_to_count[desire] < max_count:
			options = [desire]
			max_count = type_to_count[desire]
	
	madness_desire = options.pick_random()
	var desire_data = DesireData.new(madness_desire)
	desire_data.dream = self
	
	if madness_desire == primary_desire:
		desires.push_front(desire_data)
	else:
		desires.push_back(desire_data)
	
	type_to_count[madness_desire] += 1
	return desire_data
