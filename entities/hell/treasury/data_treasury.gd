class_name TreasuryData
extends Resource


var hell: HellData
var contributions: Array[ContributionData]


#region init
func _init(hell_: HellData) -> void:
	hell = hell_
	init_contributions()

func init_contributions() -> void:
	for windrose in Catalog.contribution_windroses:
		add_contribution(windrose)

func add_contribution(windrose_: Bozo.Windrose) -> void:
	var index = Catalog.windroses.find(windrose_)
	var cage = hell.jail.table.cages[index]
	var contribution = ContributionData.new(self, windrose_, cage)
	contributions.append(contribution)
#endregion


func update_contributions() -> void:
	for contribution in contributions:
		contribution.update_tokens()

#region resort
func resort(type_: Variant) -> void:
	if type_ != Bozo.Posture.MADNESS:
		contributions.sort_custom(func(a, b):
			return a.get_token(type_).value < b.get_token(type_).value
		)
	
	hell.jail.table.reset_cage()

func undo_resort() -> void:
	contributions.sort_custom(func(a, b):
		return Catalog.contribution_windroses.find(a.type) > Catalog.contribution_windroses.find(b.type)
	)
#endregion
