class_name GyreData
extends Resource


var tribunal: TribunalData
var fol: GyreData
var ere: GyreData

@export var type: Bozo.Gyre 

var sinners: Array[SinnerData]


func _init(tribunal_: TribunalData, type_: Bozo.Gyre) -> void:
	tribunal = tribunal_
	type = type_

func clear() -> void:
	if type == Bozo.Gyre.HEREAFTER: return
	sinners.shuffle()
	fol.sinners.append_array(sinners)
	sinners.clear()

func transfer_sinner() -> void:
	var sinner = sinners.pop_back()
	fol.sinners.append(sinner)
