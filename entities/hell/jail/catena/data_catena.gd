class_name CatenaData
extends Resource


signal is_selected_changed
signal z_index_changed

var table: TableData

var type: Bozo.Catena
var coord: Vector2i

var cages: Array[CageData]

var is_selected: bool = false:
	set(value_):
		if value_ != is_selected:
			is_selected = value_
			z_index = Catalog.CATENA_Z_INDEX_DEFAULT
			
			if is_selected:
				table.active_catenas.append(self)
			else:
				table.active_catenas.erase(self)
			
			emit_signal("is_selected_changed")

var z_index: int = 1:
	set(value_):
		if value_ != z_index:
			z_index = value_
			emit_signal("z_index_changed")


func _init(table_: TableData, coord_: Vector2i, type_: Bozo.Catena):
	table = table_
	coord = coord_
	type = type_
