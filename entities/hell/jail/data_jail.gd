class_name JailData
extends Resource


var hell: HellData
var table: TableData


func _init(hell_: HellData) -> void:
	hell = hell_
	table = hell.world.table
	#init_cages()
