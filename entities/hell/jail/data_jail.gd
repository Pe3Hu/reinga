class_name JailData
extends Resource


var hell: HellData
var table: TableData
var z_index_order: int = 0


func _init(hell_: HellData) -> void:
	hell = hell_
	table = TableData.new()
	table.jail = self
	#init_cages()


func update_traits() -> void:
	if Scope.layer != Bozo.Layer.HELL: return
	if table.active_cages.is_empty():
		for cage in table.cages:
			cage.status = Bozo.Cage.NONE
	else:
		var active_cage = table.active_cages.back()
		
		for cage in table.cages:
			if active_cage == cage:
				cage.status = Bozo.Cage.CENTER
			elif cage.coord.y == active_cage.coord.y or cage.coord.x == active_cage.coord.x:
				cage.status = Bozo.Cage.MIDDLE
			elif cage.coord.x > active_cage.coord.x:
				cage.status = Bozo.Cage.RIGHT
			elif cage.coord.x < active_cage.coord.x:
				cage.status = Bozo.Cage.LEFT
