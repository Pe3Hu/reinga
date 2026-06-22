class_name JailData
extends Resource


var hell: HellData
var table: TableData
var plaza: PlazaData
var platform: PlatformData

var z_index_order: int = 0
var madness_sinners: Array[SinnerData]


func _init(hell_: HellData) -> void:
	hell = hell_
	table = TableData.new()
	table.jail = self
	plaza = PlazaData.new(self)
	platform = PlatformData.new(self)

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

func reset_traits() -> void:
	if Scope.layer != Bozo.Layer.HELL: return
	for cage in table.cages:
		cage.status = Bozo.Cage.NONE

func apply_madness() -> void:
	var options: Array[CageData]
	var min_desire_count: int = table.cages.front().sinner.dream.desires.size()
	
	for option in table.cages:
		if !madness_sinners.has(option.sinner):
			var count = option.sinner.dream.desires.size()
			
			if min_desire_count == count:
				options.append(option)
			if min_desire_count > count:
				options = [option]
				min_desire_count = count
	
	var madness_cage = options.pick_random()
	madness_cage.sinner.emit_signal("is_madness")
	madness_sinners.append(madness_cage.sinner)
	print([Scope.turn, "madness", madness_sinners.size()])
