class_name GyreData
extends Resource


var tribunal: TribunalData
var fol: GyreData

@export var type: Bozo.Gyre 

var sinners: Array[SinnerData]



func _init(tribunal_: TribunalData, type_: Bozo.Gyre) -> void:
	tribunal = tribunal_
	type = type_


func clear() -> void:
	if type == Bozo.Gyre.HEREAFTER: return
	sinners
