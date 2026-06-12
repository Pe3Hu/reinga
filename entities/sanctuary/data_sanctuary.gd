class_name SanctuaryData
extends Resource


var world: WorldData

var modifiers: Array[ModifierData]
var type_to_modifier: Dictionary

var xalvorr_level: int = 0
var virello_level: int = 0


#region init
func _init(world_: WorldData) -> void:
	world = world_
	
	Scope.sanctuary = self
	init_modifiers()
	#apply_default_values()

func init_modifiers() -> void:
	for overlord in Catalog.overlord_to_modifier:
		for type in Catalog.overlord_to_modifier[overlord]:
			add_shelter(overlord, type)

func add_shelter(overlord_: Bozo.Overlord, type_: Bozo.Modifier) -> void:
	var modifier = ModifierData.new(self, overlord_, type_)
	modifiers.append(modifier)
	type_to_modifier[type_] = modifier

#func apply_default_values() -> void:
	#apply_xalvorr()
#
#func apply_xalvorr() -> void:
	#var xalvorr_modifiers: Array = Catalog.overlord_to_modifier[Bozo.Overlord.XALVORR]
	#
	#for modifier_type in xalvorr_modifiers:
		#var modifier = type_to_modifier[modifier_type]
		#modifier.value = Catalog.level_modifier_to_percent[xalvorr_level][modifier_type]
#endregion
