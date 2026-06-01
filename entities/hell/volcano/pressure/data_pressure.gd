class_name PressureData
extends Resource


var eruption: EruptionData
var type: Bozo.Modifier
var current_step: int
var limit_step: int


func _init(eruption_: EruptionData, type_: Bozo.Modifier) -> void:
	eruption = eruption_
	type = type_
	
	limit_step = max(1, Catalog.modifier_to_factor[type] * 4)
	current_step = int(limit_step)
