class_name FateData
extends TypeData


signal is_selected_changed
#signal faction_changed

var sinner: SinnerData
var faction: FactionData


var type: Bozo.Fate:
	set(value_):
		type = value_
		emit_signal("type_changed")


func _init(sinner_: SinnerData, type_: Bozo.Fate) -> void:
	sinner = sinner_
	type = type_
	faction = FactionData.new(self)

var is_selected: bool = false:
	set(value_):
		is_selected = value_
		sinner.cage.contribution.candle.is_selected = is_selected
		emit_signal("is_selected_changed")
