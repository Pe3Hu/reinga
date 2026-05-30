class_name CatenaData
extends Resource


var table: TableData

var type: Bozo.Catena
var coord: Vector2i

var cages: Array[CageData]


func _init(table_: TableData, coord_: Vector2i, type_: Bozo.Catena):
	table = table_
	coord = coord_
	type = type_
