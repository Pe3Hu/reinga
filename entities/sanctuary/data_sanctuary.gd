class_name SanctuaryData
extends Resource


var world: WorldData

var modifiers: Array[ModifierData]
var taxs: Array[TaxData]
var type_to_modifier: Dictionary
var overlord_to_claim: Dictionary

var xalvorr_level: int = 0
var virello_level: int = 0
var kharzen_level: int = 0
var calthex_level: int = 0
var sirexil_level: int = 0


#region init
func _init(world_: WorldData) -> void:
	world = world_
	
	Scope.sanctuary = self
	init_modifiers()

func init_modifiers() -> void:
	for overlord in Catalog.overlord_to_modifier:
		for type in Catalog.overlord_to_modifier[overlord]:
			add_shelter(overlord, type)

func add_shelter(overlord_: Bozo.Overlord, type_: Bozo.Modifier) -> void:
	var modifier = ModifierData.new(self, overlord_, type_)
	modifiers.append(modifier)
	type_to_modifier[type_] = modifier

func init_taxs() -> void:
	for trial in world.hell.nightmare.trials:
		var tax = trial.flame.tax
		taxs.append(tax)
#endregion
