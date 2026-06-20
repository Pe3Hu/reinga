class_name PlazaData
extends Resource


var jail: JailData
var flow: FlowData = FlowData.new()

var type_to_fate: Dictionary
var type_to_faction: Dictionary
var type_to_trait_to_value: Dictionary

var hope_shift: int = 0


func _init(jail_: JailData) -> void:
	jail = jail_
	flow.plaza = self
	flow.nightmare = jail.hell.nightmare

#region association
func update_associations() -> void:
	type_to_fate.clear()
	type_to_faction.clear()
	hope_shift = 0
	
	for cage in jail.table.cages:
		var fate = cage.sinner.fate
		var faction = cage.sinner.fate.faction
		
		if !Catalog.trust_fates.has(fate.type):
			if !type_to_fate.has(fate.type):
				type_to_fate[fate.type] = []
			
			type_to_fate[fate.type].append(fate)
		
		if !Catalog.special_factions.has(faction.type):
			if !type_to_faction.has(faction.type):
				type_to_faction[faction.type] = []
			
			type_to_faction[faction.type].append(faction)
		else:
			if faction.type == Bozo.Faction.LEGEND:
				match fate.relationship:
					Bozo.Relationship.ALLY:
						hope_shift -= 1
					Bozo.Relationship.ENEMY:
						hope_shift += 1
	
	var types = type_to_faction.keys()
	
	for _i in range(types.size() -1, -1, -1):
		var faction_type = types[_i]
		
		if type_to_faction[faction_type].size() >= Catalog.HOPE_LIMIT + hope_shift:
			for faction in type_to_faction[faction_type]:
				faction.association = Bozo.Association.BROTHERHOOD
		else:
			type_to_faction.erase(faction_type)
	
	types = type_to_fate.keys()
	
	for _i in range(types.size() -1, -1, -1):
		var fate_type = types[_i]
		
		if type_to_fate[fate_type].size() >= Catalog.TRUST_LIMIT:
			for fate in type_to_fate[fate_type]:
				fate.association = Bozo.Association.GUILD
		else:
			type_to_fate.erase(fate_type)
	
	apply_guilds()

func apply_guilds() -> void:
	for fate_type in type_to_fate:
		for fate in type_to_fate[fate_type]:
			fate.sinner.dream.apply_guild()
	
	apply_trust_logic()
	
func apply_trust_logic() -> void:
	var fate_type_to_count: Dictionary = {}
	
	for cage in jail.table.cages:
		var fate_type = cage.sinner.fate.type
		
		if Catalog.trust_fates.has(fate_type):
			continue
		
		if !fate_type_to_count.has(fate_type):
			fate_type_to_count[fate_type] = 0
		
		fate_type_to_count[fate_type] += 1
		
	for cage in jail.table.cages:
		var fate = cage.sinner.fate
		
		if Catalog.trust_fates.has(fate.type):
			fate.sinner.dream.apply_guild()
			fate.association = Bozo.Association.GUILD
		else:
			var trust_counter = fate_type_to_count.get(fate.type, 0)
			
			for neighbour in cage.neighbours:
				var neighbour_fate = neighbour.sinner.fate.type
				
				if !Catalog.trust_fates.has(neighbour_fate):
					continue
				
				var relationship = Catalog.fate_to_relationship.get(neighbour_fate, Bozo.Relationship.NONE)
				
				if relationship == Bozo.Relationship.NONE:
					continue
				
				trust_counter += Catalog.relationship_to_sign[relationship]
			
			var is_trust = trust_counter >= Catalog.TRUST_LIMIT 
			fate.sinner.dream.apply_guild(is_trust)
			
			if is_trust:
				fate.association = Bozo.Association.GUILD
			else:
				fate.association = Bozo.Association.NONE

func reset_associations() -> void:
	for cage in jail.table.cages:
		var fate = cage.sinner.fate
		fate.association = Bozo.Association.NONE
		var faction = cage.sinner.fate.faction
		faction.association = Bozo.Association.NONE
		var dream = cage.sinner.dream
		dream.reset_associations()
#endregion

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
