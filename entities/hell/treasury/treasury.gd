class_name Treasury
extends PanelContainer


@export var contribution_scene: PackedScene

@export var hell: Hell
@export var sort_icon: TextureRect
@export var lock_button: CustomButton

var contributions: Array[Contribution]


func _ready() -> void:
	init_contributions()

#region init
func init_contributions() -> void:
	for windrose in Catalog.contribution_windroses:
		add_contribution(windrose)

func add_contribution(windrose_: Bozo.Windrose) -> void:
	var contribution = contribution_scene.instantiate()
	var index = Catalog.windroses.find(windrose_)
	var cage = hell.jail.cages[index]
	%Contributions.add_child(contribution)
	contributions.append(contribution)
	contribution.treasury = self
	contribution.candle.windrose = windrose_
	contribution.cage = cage
	cage.contribution = contribution

func get_contribution(windrose_: Bozo.Windrose) -> Contribution:
	var index = Catalog.contribution_windroses.find(windrose_)
	return contributions[index]
#endregion

func appraisement_preparation() -> void:
	show_vbox()
	show_all_contributions()
	update_contributions()
	resort_judgment(Bozo.Judgment.RANK)
	reorder_contribution()

func update_contributions() -> void:
	for contribution in contributions:
		contribution.update_tokens()

#region resort
func resort(token_: Token) -> void:
	if token_ is TokenSin:
		resort_sin(token_.type)
	if token_ is TokenPosture:
		resort_posture(token_.type)
	if token_ is TokenJudgment:
		resort_judgment(token_.type)
	
	reorder_contribution()
	hell.jail.reset_active_cage()
	sort_icon_shift(token_)

func resort_sin(type_: Bozo.Sin) -> void:
	contributions.sort_custom(func(a, b):
		return a.get_token(type_).value < b.get_token(type_).value
	)

func resort_posture(type_: Bozo.Posture) -> void:
	if type_ == Bozo.Posture.MADNESS: return
	contributions.sort_custom(func(a, b):
		return a.get_token(type_).value < b.get_token(type_).value
	)

func resort_judgment(type_: Bozo.Judgment) -> void:
	contributions.sort_custom(func(a, b):
		return a.get_token(type_).value < b.get_token(type_).value
	)

func reorder_contribution() -> void:
	for _i in range(contributions.size()):
		%Contributions.move_child(contributions[_i], _i)

func undo_resort() -> void:
	contributions.sort_custom(func(a, b):
		return Catalog.contribution_windroses.find(a.candle.windrose) > Catalog.contribution_windroses.find(b.candle.windrose)
	)
	reorder_contribution()
	hell.jail.reset_active_cage()

func sort_icon_shift(token_: Token) -> void:
	if token_.type == Bozo.Posture.MADNESS: return
	var best_contribution = contributions.back()
	var best_token = best_contribution.get_token(token_.type)
	sort_icon.global_position.y = best_token.global_position.y - 4
	sort_icon.visible = true
#endregion

func hide_not_selected_contributions() -> void:
	for contribution in contributions:
		contribution.visible = contribution.cage == hell.jail.active_cage

func show_all_contributions() -> void:
	for contribution in contributions:
		contribution.visible = true

func hide_vbox() -> void:
	%VBox.visible = false

func show_vbox() -> void:
	%VBox.visible = true

func _on_lock_button_pressed() -> void:
	lock_button.visible = false
	hell.jail.is_locked = true
	
	hide_not_selected_contributions()
	Scope.in_progress = false
	Scope.next_phase()
