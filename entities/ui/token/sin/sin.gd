@tool
class_name TokenSin
extends Token


@export var contribution: Contribution


func _on_value_changed() -> void:
	super._on_value_changed()

func apply_data_info() -> void:
	super.apply_data_info()
	if !data.type_changed.is_connected(_on_type_changed):
		data.type_changed.connect(_on_type_changed)
	_on_type_changed()

func _on_type_changed() -> void:
	if data.type == 0: return
	texture_rect.texture = load("res://entities/ui/token/sin/sin.png")
	texture_rect.modulate = Catalog.sin_to_color[data.type]

func click_event() -> void:
	super.click_event()
	if contribution != null:
		contribution.treasury.reoder(data.type)
		await get_tree().process_frame
		contribution.treasury.sort_icon_shift(self)
