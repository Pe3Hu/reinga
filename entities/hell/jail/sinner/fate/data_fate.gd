class_name FateData
extends TypeData


signal is_selected_changed
signal association_changed

var sinner: SinnerData
var faction: FactionData


var tooltip: Bozo.Tooltip = Bozo.Tooltip.FATE
var type: Bozo.Fate:
	set(value_):
		type = value_
		emit_signal("type_changed")

var is_selected: bool = false:
	set(value_):
		if is_selected == value_:
			return
		is_selected = value_
		
		var cage = sinner.cage if sinner else null
		if cage != null and cage.table != null and cage.table.jail != null:
			if cage.contribution != null and cage.contribution.candle != null:
				cage.contribution.candle.is_selected = value_
			cage.table.jail.update_traits()
		
		emit_signal("is_selected_changed")

var association: Bozo.Association:
	set(value_):
		if association != value_:
			association = value_
			emit_signal("association_changed")

var relationship: Bozo.Relationship = Bozo.Relationship.NONE


#region init
func _init(sinner_: SinnerData, type_: Bozo.Fate) -> void:
	sinner = sinner_
	type = type_
	faction = FactionData.new(self)
	
	apply_special()

func apply_special() -> void:
	if !Catalog.special_fates.has(type): return
	relationship = Catalog.fate_to_relationship[type]
	#match faction.type:
		#Bozo.Faction.TRUST:
			#association = Catalog.faction_to_association[faction.type]
		#Bozo.Faction.HOPE:
			#faction.association = Catalog.faction_to_association[faction.type]
#endregion
