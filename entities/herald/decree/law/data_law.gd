class_name LawData
extends Resource



var decree: DecreeData
var modifier: Bozo.Modifier

var old_value: int
var new_value: int
var blob: Bozo.Blob


func _init(decree_: DecreeData, modifier_: Bozo.Modifier) -> void:
	decree = decree_
	modifier = modifier_
	
	init_values()

func init_values() -> void:
	pass

func apply() -> void:
	pass
