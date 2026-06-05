class_name DoomData
extends Resource


var omens: Array[OmenData]
var destiny: OmenData = OmenData.new(Bozo.Omen.DESTINY)
var family: OmenData = OmenData.new(Bozo.Omen.FAMILY)


func _init() -> void:
	omens = [
		destiny,
		family
	]
