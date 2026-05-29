@tool
class_name TokenSin
extends Token



func _on_value_changed() -> void:
	super._on_value_changed()
	visible = true

func apply_data_info() -> void:
	super.apply_data_info()
	apply_type()

func apply_type() -> void:
	if data.type == 0: return
	texture_rect.texture = load("res://entities/ui/token/images/sin.png")
	texture_rect.modulate = Catalog.sin_to_color[data.type]
