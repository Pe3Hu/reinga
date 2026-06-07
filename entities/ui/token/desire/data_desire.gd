class_name DesireData
extends TokenData


signal association_changed

var dream: DreamData
var type: Bozo.Desire:
	set(value_):
		type = value_
		emit_signal("type_changed")

var association: Bozo.Association = Bozo.Association.NONE:
	set(value_):
		association = value_
		emit_signal("association_changed")


func _init(dream_: DreamData, type_: Bozo.Desire, value_: int = 1) -> void:
	dream = dream_
	type = type_
	value = value_
