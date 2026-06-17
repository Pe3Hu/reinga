class_name LawData
extends Resource


var decree: DecreeData
var modifier: Bozo.Modifier

var old_value: int
var new_value: int
var blob: Bozo.Blob

var old_text: String
var new_text: String

var fate: Bozo.Fate
var fate_text: String


#region init
func _init(decree_: DecreeData, modifier_: Bozo.Modifier, fate_: Bozo.Fate = Bozo.Fate.NONE) -> void:
	decree = decree_
	modifier = modifier_
	fate = fate_
	
	init_values()
	init_texts()

func init_values() -> void:
	if fate != Bozo.Fate.NONE: return
	#var sanctuary_modifier = decree.herald.world.sanctuary.type_to_modifier[modifier]
	old_value = Helper.get_modifier_rank_value(modifier)
	new_value = Helper.get_modifier_rank_value(modifier, decree.rank_shift)
	
	if old_value == new_value:
		return
	
	if new_value > old_value:
		blob = Bozo.Blob.PLUS
	else:
		blob = Bozo.Blob.MINUS

func init_texts() -> void:
	if fate == Bozo.Fate.NONE:
		new_text = str(new_value)
		old_text = str(old_value)
		
		match decree.overlord.type:
			Bozo.Overlord.VIRELLO:
				var sanctuary_modifier = decree.herald.world.sanctuary.type_to_modifier[modifier]
				var min_value = new_value - sanctuary_modifier.subvalue
				var max_value = new_value + sanctuary_modifier.subvalue
				new_text = "%d - %d" % [min_value, max_value]
				
				min_value = old_value - sanctuary_modifier.subvalue
				max_value = old_value + sanctuary_modifier.subvalue
				old_text = "%d - %d" % [min_value, max_value]
			Bozo.Overlord.XALVORR:
				new_text += "%"
				old_text += "%"
			Bozo.Overlord.MARVONE:
				new_text += "%"
				old_text += "%"
	else:
		fate_text = Catalog.fate_to_string[fate].capitalize()
		
		if modifier == Bozo.Modifier.TRUST:
			fate_text = "[tornado radius=4 freq=1.6]%s" % fate_text
#endregion

func apply() -> void:
	if fate != Bozo.Fate.NONE:
		decree.herald.world.tribunal.add_sinner(fate)
	else:
		var sanctuary_modifier = decree.herald.world.sanctuary.type_to_modifier[modifier]
		sanctuary_modifier.value = new_value
		
		match decree.overlord.type:
			Bozo.Overlord.CALTHEX:
				var factor_shift = Catalog.blob_to_shift[blob]
				var spectalce_type = Catalog.modifier_to_spectacle[modifier]
				Scope.spectacle_to_factor[spectalce_type] += factor_shift
