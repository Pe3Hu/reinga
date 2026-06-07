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


#region init
func _init(sinner_: SinnerData) -> void:
	sinner = sinner_
	
	init_desires()

func init_desires() -> void:
	var trial = Helper.get_random_key(Catalog.faction_to_trial[sinner.fate.faction.type])
	
	var primary_data = DesireData.new(self, Catalog.trial_to_desire[trial])
	primary_desire = primary_data.type
	desires.append(primary_data)
	
	primary_data = DesireData.new(self, Catalog.trial_to_desire[trial])
	desires.append(primary_data)
	
	var desire_options = []
	desire_options.append_array(Catalog.desires)
	desire_options.erase(primary_desire)
	desire_options.shuffle()
	secondary_desire = desire_options.pick_random()
	var secondary_data = DesireData.new(self, secondary_desire)
	desires.append(secondary_data)
	
	if Catalog.special_fates.has(sinner.fate.type):
		primary_data.value = 0
		secondary_data.value = 0
	
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
