class_name Treasury
extends PanelContainer


var data: TreasuryData:
	set(value_):
		data = value_
		init_contributions()

@export var contribution_scene: PackedScene

@export var hell: Hell
@export var sort_icon: TextureRect
@export var lock_button: CustomButton

var contributions: Array[Contribution]


#region init
func init_contributions() -> void:
	for data_contribution in data.contributions:
		add_contribution(data_contribution)

func add_contribution(data_: ContributionData) -> void:
	var contribution = contribution_scene.instantiate()
	%Contributions.add_child(contribution)
	contribution.data = data_
	contribution.treasury = self
	for cage in hell.jail.cages:
		if cage.data == data_.cage:
			contribution.cage = cage
			break
	contributions.append(contribution)

func get_contribution(windrose_: Bozo.Windrose) -> Contribution:
	var index = Catalog.contribution_windroses.find(windrose_)
	return contributions[index]
#endregion

func appraisement_preparation() -> void:
	show_vbox()
	show_all_contributions()
	data.update_contributions()
	data.resort_judgment(Bozo.Judgment.TRIBUTE)
	reorder_contribution()

func reorder_contribution() -> void:
	contributions.sort_custom(func (a, b): data.contributions.find(a.data) > data.contributions.find(b.data))

	for _i in range(contributions.size()-1, -1, -1):
		%Contributions.move_child(contributions[_i], _i)

func undo_resort() -> void:
	contributions.sort_custom(func(a, b):
		return Catalog.contribution_windroses.find(a.data.type) > Catalog.contribution_windroses.find(b.data.type)
	)
	reorder_contribution()
	hell.jail.reset_active_cage()



func sort_icon_shift(token_: Token) -> void:
	if token_.data.type == Bozo.Posture.MADNESS: return
	var best_contribution = contributions.back()
	var best_token = best_contribution.get_token(token_.data.type)
	sort_icon.global_position.y = best_token.global_position.y - 4
	sort_icon.visible = true


func hide_not_selected_contributions() -> void:
	for contribution in contributions:
		contribution.visible = contribution.cage.data == hell.jail.data.table.active_cage

func show_all_contributions() -> void:
	for contribution in contributions:
		contribution.visible = true

func hide_vbox() -> void:
	%VBox.visible = false

func show_vbox() -> void:
	%VBox.visible = true

func _on_lock_button_pressed() -> void:
	lock()
	Scope.next_phase()

func lock() -> void:
	lock_button.visible = false
	hell.jail.data.table.is_locked = true
	#hide_not_selected_contributions()
