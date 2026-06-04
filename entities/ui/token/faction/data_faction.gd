class_name FactionData
extends TokenData


signal association_changed

var fate: FateData
var type: Bozo.Faction:
	set(value_):
		type = value_
		emit_signal("type_changed")

var association: Bozo.Association:
	set(value_):
		if association != value_:
			association = value_
			emit_signal("association_changed")


func _init(fate_: FateData) -> void:
	fate = fate_
	type = Catalog.fate_to_faction[fate.type]

func get_token_for_eruptions() -> Array:
	var type_to_sin: Dictionary
	var sins: Array[SinData]
	var plaza = fate.sinner.cage.table.jail.plaza
	
	#theater attitude
	if true:
		var traits = [fate.sinner.soul.guilt]
		
		for _trait in traits:
			for trait_sin in _trait.sins:
				if !type_to_sin.has(trait_sin.type):
					type_to_sin[trait_sin.type] = SinData.new(trait_sin.type)
				
				type_to_sin[trait_sin.type].value += trait_sin.value
				
				if !plaza.type_to_trait_to_value.has(trait_sin.type):
					plaza.type_to_trait_to_value[trait_sin.type] = {}
				
				plaza.type_to_trait_to_value[trait_sin.type][_trait] = trait_sin.value
	
	
	for key in type_to_sin:
		sins.append(type_to_sin[key])
	
	
	return sins
