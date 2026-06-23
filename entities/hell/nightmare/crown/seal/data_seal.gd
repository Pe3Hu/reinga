class_name SealData
extends Resource


var crown: CrownData
var type: Bozo.Seal
var value: int = 0


func _init(crown_: CrownData, type_: Bozo.Seal) -> void:
	crown = crown_
	type = type_
