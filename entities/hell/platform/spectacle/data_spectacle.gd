class_name SpectacleData
extends TypeData


var catena: CatenaData
var type: Bozo.Spectacle:
	set(value_):
		type = value_

var cages: Array[CageData]


func _init(catena_: CatenaData) -> void:
	catena = catena_
	type = Catalog.catena_to_spectacle[catena.type]
