class_name PlatformData
extends TypeData


var jail: JailData
var spectacles: Array[SpectacleData]
var freshs: Array[CageData]
var ripes: Array[CageData]
var rottens: Array[CageData]


func _init(jail_: JailData) -> void:
	jail = jail_

func apply_performance() -> void:
	for spectacle in spectacles:
		pass

func harvest() -> void:
	while !rottens.is_empty():
		var cage = rottens.pop_back()
		cage.fruit = Bozo.Fruit.NONE
	
	while !ripes.is_empty():
		var cage = ripes.pop_back()
		cage.fruit = Bozo.Fruit.ROTTEN
		rottens.append(cage)
	
	while !freshs.is_empty():
		var cage = freshs.pop_back()
		cage.fruit = Bozo.Fruit.RIPE
		ripes.append(cage)
