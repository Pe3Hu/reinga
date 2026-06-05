class_name DesireData
extends TokenData


signal association_changed

var type: Bozo.Desire:
	set(value_):
		type = value_
		emit_signal("type_changed")

var association: Bozo.Association = Bozo.Association.NONE:
	set(value_):
		association = value_
		emit_signal("association_changed")


func _init(type_: Bozo.Desire, value_: int = 0) -> void:
	type = type_
	value = value_
