class_name PostureData
extends TokenData


var trait_data: TraitData
var tooltip: Bozo.Tooltip = Bozo.Tooltip.MADNESS
var type: Bozo.Posture:
	set(value_):
		type = value_
	
		match type:
			Bozo.Posture.MADNESS:
				tooltip = Bozo.Tooltip.MADNESS
			Bozo.Posture.OBLIVION:
				tooltip = Bozo.Tooltip.OBLIVION
		
		emit_signal("type_changed")


func _init(type_: Bozo.Posture, value_: int = 0) -> void:
	type = type_
	value = value_
