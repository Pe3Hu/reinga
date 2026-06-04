class_name PlazaData
extends Resource


var jail: JailData

var type_to_fate: Dictionary
var type_to_faction: Dictionary
var type_to_trait_to_value: Dictionary


func _init(jail_: JailData) -> void:
	jail = jail_

func update_associations() -> void:
	type_to_fate.clear()
	type_to_faction.clear()
	
	for cage in jail.table.cages:
		var fate = cage.sinner.fate
		var faction = cage.sinner.fate.faction
		
		if !type_to_fate.has(fate.type):
			type_to_fate[fate.type] = []
		
		type_to_fate[fate.type].append(fate)
		
		if !type_to_faction.has(faction.type):
			type_to_faction[faction.type] = []
		
		type_to_faction[faction.type].append(faction)
	
	var types = type_to_faction.keys()
	
	for _i in range(types.size() -1, -1, -1):
		var faction_type = types[_i]
		
		if type_to_faction[faction_type].size() >= Catalog.PLAZA_FACTION_LIMIT:
			for faction in type_to_faction[faction_type]:
				faction.association = Bozo.Association.BROTHERHOOD
		else:
			type_to_faction.erase(faction_type)
	
	types = type_to_fate.keys()
	
	for _i in range(types.size() -1, -1, -1):
		var fate_type = types[_i]
		
		if type_to_fate[fate_type].size() >= Catalog.PLAZA_FATE_LIMIT:
			for fate in type_to_fate[fate_type]:
				fate.association = Bozo.Association.GUILD
		else:
			type_to_fate.erase(fate_type)

func reset_associations() -> void:
	for cage in jail.table.cages:
		var fate = cage.sinner.fate
		fate.association = Bozo.Association.NONE
		var faction = cage.sinner.fate.faction
		faction.association = Bozo.Association.NONE

func get_available_token(sin_type_: Bozo.Token) -> TokenData:
	var options = type_to_trait_to_value[sin_type_].keys()
	var trait_data = options.pick_random()
	var sin_data = trait_data.type_to_token[sin_type_]
	type_to_trait_to_value[sin_type_][trait_data] -= 1
	
	if type_to_trait_to_value[sin_type_][trait_data] == 0:
		type_to_trait_to_value[sin_type_].erase(trait_data)
	
	if type_to_trait_to_value[sin_type_].keys().is_empty():
		type_to_trait_to_value.erase(sin_type_)
	
	return sin_data
