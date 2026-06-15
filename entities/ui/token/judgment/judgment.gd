@tool
class_name TokenJudgment
extends Token


@export var contribution: Contribution


func connect_signals() -> void:
	super.connect_signals()
	data.type_changed.connect(_on_type_changed)
	_on_type_changed()

func _on_type_changed() -> void:
	if data.type == 0: return
	texture_rect.modulate = Catalog.judgment_to_color[data.type]

func click_event() -> void:
	super.click_event()
	if contribution != null:
		contribution.treasury.reoder(data.type)
		await get_tree().process_frame
		contribution.treasury.sort_icon_shift(self)
