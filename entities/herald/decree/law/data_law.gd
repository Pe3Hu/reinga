class_name LawData
extends Resource


var decree: DecreeData
var modifier: Bozo.Modifier

var old_value: int
var new_value: int
var blob: Bozo.Blob

var old_text: String
var new_text: String


#region init
func _init(decree_: DecreeData, modifier_: Bozo.Modifier) -> void:
	decree = decree_
	modifier = modifier_
	
	init_values()

func init_values() -> void:
	#var sanctuary_modifier = decree.herald.world.sanctuary.type_to_modifier[modifier]
	old_value = Helper.get_modifier_rank_value(modifier)
	new_value = Helper.get_modifier_rank_value(modifier, decree.rank_shift)
	
	if old_value == new_value:
		return
	
	if new_value > old_value:
		blob = Bozo.Blob.PLUS
	else:
		blob = Bozo.Blob.MINUS
	
	init_texts()

func init_texts() -> void:
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
#endregion

func apply() -> void:
	var sanctuary_modifier = decree.herald.world.sanctuary.type_to_modifier[modifier]
	sanctuary_modifier.value = new_value
	decree.herald.reinit_decree(decree.overlord.type)
