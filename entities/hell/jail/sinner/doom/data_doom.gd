class_name DoomData
extends Resource


var soul: SoulData
var omens: Array[OmenData]
var destiny: OmenData 
var family: OmenData


func _init(soul_: SoulData) -> void:
	soul = soul_
	
	#roll_omens()

func roll_omens() -> void:
	var options: Array[Bozo.Omen]
	options.append_array(Catalog.omens)
	options.shuffle()
	
	var count  = randi_range(0, 2)
	count = 0
	
	for _i in count:
		options.pop_back()
	
	while !options.is_empty():
		var omen_type = options.pop_back()
		var omen = OmenData.new(omen_type)
		var subtype = roll_subtype(omen)
		
		if subtype != null:
			omen.subtype = subtype
			omens.append(omen)
			set(Catalog.omen_to_string[omen_type], omen)
	

func roll_subtype(omen_: OmenData) -> Variant:
	if omen_.type == Bozo.Omen.NONE: return
	var subtype: Variant = null
	
	match omen_.type:
		Bozo.Omen.FAMILY:
			subtype = roll_family_subtype()
		Bozo.Omen.DESTINY:
			subtype = roll_destiny_subtype()
	
	return subtype

func roll_destiny_subtype() -> Variant:
	var subtype: Variant
	var fate = soul.sinner.fate.type
	var faction = Catalog.fate_to_faction[fate]
	var weights: Dictionary
	
	if !omens.is_empty():
		var origin_omen = omens.front()
		var keys = Catalog.faction_to_destiny[faction].keys()
		
		for _i in range(keys.size()-1, -1, -1):
			var key = keys[_i]
			
			if Catalog.omen_to_omen[origin_omen.subtype].has(key):
				weights[key] = Catalog.faction_to_destiny[faction][key]
	else:
		weights = Catalog.faction_to_destiny[faction]
	
	if !weights.is_empty():
		subtype = Helper.get_random_key(weights)
	
	return subtype 

func roll_family_subtype() -> Variant:
	var subtype: Variant
	var fate = soul.sinner.fate.type
	var weights: Dictionary
	
	if !omens.is_empty():
		var origin_omen = omens.front()
		var keys = Catalog.fate_to_family[fate].keys()
		
		for _i in range(keys.size()-1, -1, -1):
			var key = keys[_i]
			
			if Catalog.omen_to_omen[origin_omen.subtype].has(key):
				weights[key] = Catalog.fate_to_family[fate][key]
	else:
		weights = Catalog.fate_to_family[fate]
		
	if !weights.is_empty():
		var family_subtype = Helper.get_random_key(weights) 
		subtype = Catalog.family_to_family[family_subtype]
	
	return subtype 
