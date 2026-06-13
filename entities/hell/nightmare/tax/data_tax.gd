class_name TaxData
extends Resource


var flame: FlameData

var tooltip: Bozo.Tooltip = Bozo.Tooltip.TAX
var sins: Array[SinData]
var type_to_sin: Dictionary
var sit_to_weight: Dictionary


#region Новая область кода
func _init(flame_: FlameData) -> void:
	flame = flame_
	init_sins()

func init_sins() -> void:
	for sin_data in flame.trial.claim.sins:
		add_sin(sin_data)

func add_sin(donor_data_: SinData) -> void:
	var sin_data = SinData.new(donor_data_.type, donor_data_.value)
	sins.append(sin_data)
#endregion

func update_sins() -> void:
	for _i in sins.size():
		var _sin = sins[_i]
		
		if Catalog.flame_to_claim.has(flame.level):
			_sin.value = Catalog.flame_to_claim[flame.level][_i]

func swap_sin_type(old_type_: Bozo.Sin, new_type_: Bozo.Sin) -> void:
	for _sin in sins:
		if _sin.type == old_type_:
			_sin.type = new_type_
			return
