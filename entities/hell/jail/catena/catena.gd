extends Control
class_name Catena


var jail: Jail
var type: Bozo.Catena
var coord: Vector2i

var cages: Array[Cage]


func setup(jail_: Jail, coord_: Vector2i, type_: Bozo.Catena):
	jail = jail_
	coord = coord_
	type = type_

func highligh_cages() -> void:
	for cage in cages:
		cage.status = Bozo.Cage.MIDDLE
