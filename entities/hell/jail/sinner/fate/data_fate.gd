class_name FateData
extends TypeData


signal is_selected_changed
signal association_changed

var sinner: SinnerData
var faction: FactionData


var type: Bozo.Fate:
	set(value_):
		type = value_
		emit_signal("type_changed")

var is_selected: bool = false:
	set(value_):
		if is_selected != value_:
			is_selected = value_
			
			if sinner.cage.table.jail:
				sinner.cage.contribution.candle.is_selected = value_
				sinner.cage.table.jail.update_traits()
			
			emit_signal("is_selected_changed")

var association: Bozo.Association:
	set(value_):
		if association != value_:
			association = value_
			emit_signal("association_changed")


func _init(sinner_: SinnerData, type_: Bozo.Fate) -> void:
	sinner = sinner_
	type = type_
	faction = FactionData.new(self)
